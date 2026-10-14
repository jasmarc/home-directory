#!/usr/bin/env bash
# doctor.sh — report-only health check for this dotfiles setup.
#
#   ./doctor.sh                 check this machine
#   ./doctor.sh --remote HOST   run the same checks on HOST over ssh (nothing is copied there)
#   ./doctor.sh --fetch         also `git fetch` so "behind origin" is current
#
# It never installs, links, or edits anything. Each line is:
#   ✓ ok   ✗ broken (exit code 1)   ? can't verify / worth a look
# with a "→ Fix:" hint where there's an obvious one.
#
# Machine-specific checks (work tools, auth, schedulers) live OUTSIDE this public
# repo in ~/.config/doctor.d/*.sh. Each file defines functions named doctor_check_*
# that use the same pass/fail/warn helpers; they run after the core checks.
# Must stay bash 3.2 compatible (macOS /bin/bash).

DOCTOR_REPO="${DOCTOR_REPO:-$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd)}"
DOCTOR_D="${DOCTOR_D:-$HOME/.config/doctor.d}"
DOCTOR_FAILS=0; DOCTOR_WARNS=0; DOCTOR_OKS=0

if [ -t 1 ]; then G=$'\033[0;32m'; R=$'\033[0;31m'; Y=$'\033[0;33m'; D=$'\033[0;90m'; B=$'\033[1m'; N=$'\033[0m'
else G=; R=; Y=; D=; B=; N=; fi

pass() { DOCTOR_OKS=$((DOCTOR_OKS+1));   printf '  %s✓%s %s\n' "$G" "$N" "$1"; }
fail() { DOCTOR_FAILS=$((DOCTOR_FAILS+1)); printf '  %s✗%s %s\n' "$R" "$N" "$1"; [ -n "$2" ] && printf '    %s→ Fix: %s%s\n' "$D" "$2" "$N"; return 0; }
warn() { DOCTOR_WARNS=$((DOCTOR_WARNS+1)); printf '  %s?%s %s\n' "$Y" "$N" "$1"; [ -n "$2" ] && printf '    %s→ %s%s\n' "$D" "$2" "$N"; return 0; }
section() { printf '\n%s%s%s\n' "$B" "$1" "$N"; }
have() { command -v "$1" >/dev/null 2>&1; }

# Look for a tool on PATH, then in the usual install dirs. Finding it off-PATH is the
# classic "installed but this shell can't see it" case, which is a different fix.
find_tool() {
  local t="$1" d
  if have "$t"; then command -v "$t"; return 0; fi
  for d in "$HOME/.toolbox/bin" /home/linuxbrew/.linuxbrew/bin /opt/homebrew/bin /usr/local/bin "$HOME/.local/bin"; do
    [ -x "$d/$t" ] && { echo "OFFPATH:$d/$t"; return 0; }
  done
  return 1
}

check_tool() {  # name  fix-hint
  local where; where=$(find_tool "$1") || { fail "$1 not installed" "$2"; return; }
  case "$where" in
    OFFPATH:*) warn "$1 installed but not on PATH (${where#OFFPATH:})" "add its directory to PATH (on a remote host: ~/.zshenv)";;
    *) pass "$1";;
  esac
}

# ---------------------------------------------------------------- core checks
doctor_core_shell() {
  section "Shell"
  local login
  if [ "$(uname -s)" = Darwin ]; then login=$(dscl . -read "/Users/$USER" UserShell 2>/dev/null | awk '{print $2}')
  else login=$(getent passwd "$USER" 2>/dev/null | cut -d: -f7); fi
  pass "login shell: ${login:-unknown}"
  local fishbin; fishbin=$(find_tool fish)
  if [ -n "$fishbin" ]; then
    case "$fishbin" in OFFPATH:*) fishbin=${fishbin#OFFPATH:};; esac
    pass "fish $("$fishbin" --version 2>/dev/null | awk '{print $NF}')"
    if [ -f "$HOME/.config/fish/fish_plugins" ] && "$fishbin" -c 'functions -q fisher' 2>/dev/null; then
      local want got missing
      want=$(sort -u "$HOME/.config/fish/fish_plugins" | grep -v '^$')
      got=$("$fishbin" -c 'fisher list' 2>/dev/null | sort -u)
      missing=$(comm -23 <(echo "$want") <(echo "$got") | tr '\n' ' ')
      if [ -z "$missing" ]; then pass "fisher plugins match fish_plugins"
      else warn "fisher plugins not installed: $missing" "fish -c 'fisher update'"; fi
    fi
  else
    warn "fish not found" "brew install fish"
  fi
}

doctor_core_brew() {
  section "Homebrew tools"
  if ! find_tool brew >/dev/null; then fail "brew not installed" "see https://brew.sh"; return; fi
  local line tool pkg list="$DOCTOR_REPO/brew-tools.txt"
  if [ -z "$DOCTOR_BREW_TOOLS" ]; then
    [ -f "$list" ] || { warn "brew-tools.txt not found next to doctor.sh"; return; }
    DOCTOR_BREW_TOOLS=$(cat "$list")
  fi
  for line in $DOCTOR_BREW_TOOLS; do
    tool=${line%%:*}; pkg=${line#*:}
    check_tool "$tool" "brew install $pkg"
  done
}

doctor_core_repo() {
  section "Dotfiles repo"
  local r="$DOCTOR_REPO"
  if [ ! -d "$r/.git" ] && ! git -C "$r" rev-parse --git-dir >/dev/null 2>&1; then
    fail "$r is not a git checkout (a copied snapshot drifts silently)" "git clone the repo instead of copying it"; return
  fi
  [ "$DOCTOR_FETCH" = 1 ] && git -C "$r" fetch -q 2>/dev/null
  local br dirty behind ahead
  br=$(git -C "$r" rev-parse --abbrev-ref HEAD 2>/dev/null)
  dirty=$(git -C "$r" status --porcelain 2>/dev/null | wc -l | tr -d ' ')
  if [ "$dirty" = 0 ]; then pass "clean working tree (branch $br)"
  else warn "$dirty uncommitted change(s) on $br" "review: git -C $r status"; fi
  if git -C "$r" rev-parse --abbrev-ref '@{u}' >/dev/null 2>&1; then
    behind=$(git -C "$r" rev-list --count 'HEAD..@{u}' 2>/dev/null); ahead=$(git -C "$r" rev-list --count '@{u}..HEAD' 2>/dev/null)
    if [ "${behind:-0}" -gt 0 ]; then warn "$behind commit(s) behind upstream" "git -C $r pull --rebase"
    else pass "up to date with upstream${DOCTOR_FETCH:+ (fetched)}"; fi
    [ "${ahead:-0}" -gt 0 ] && warn "$ahead local commit(s) not pushed"
  else
    warn "branch $br has no upstream"
  fi
}

# A link "X/X" (a directory containing a link to itself or its source) is what
# `ln -sf src existing-dir` creates by accident.
doctor_core_links() {
  section "Links"
  have realpath || { warn "realpath not available; skipping link checks"; return; }
  local r="$DOCTOR_REPO" item rel tgt bad=0 ok=0 foreign=""
  # first-level entries of each package (config/ carries its own .config/ layer)
  for item in "$r/home"/.[!.]* "$r/home"/* "$r/config/.config"/*; do
    [ -e "$item" ] || continue
    case "$item" in "$r/home/.config"|"$r/home/Library"|*/.DS_Store) continue;; esac
    rel=${item#"$r/home/"}; rel=${rel#"$r/config/"}; tgt="$HOME/$rel"
    if [ -L "$tgt" ] && [ ! -e "$tgt" ]; then fail "dangling link ~/$rel" "remove it, then re-run setup.sh"; bad=$((bad+1)); continue; fi
    [ -e "$tgt" ] || continue
    if [ "$(realpath "$tgt")" = "$(realpath "$item")" ]; then ok=$((ok+1))
    elif [ -d "$tgt" ] && [ ! -L "$tgt" ]; then :   # real dir holding per-file links; fine
    else foreign="$foreign ~/$rel"; fi
  done
  [ "$ok" -gt 0 ] && pass "$ok repo-managed entries link into the repo"
  [ -n "$foreign" ] && warn "present but not linked to the repo:$foreign" "if they should be: ./setup.sh (it shows conflicts before changing anything)"
  local d n
  for d in "$HOME/.zshrc.d" "$HOME/.fishrc.d" "$HOME/.config"; do
    n="$d/$(basename "$d")"
    if [ -e "$n" ] || [ -L "$n" ]; then fail "nested self-link ${n/#$HOME/~}" "remove that inner entry"; bad=$((bad+1)); fi
  done
  [ "$bad" = 0 ] && pass "no dangling or nested self-links"
}

# Report COUNTS only, never values. Scans what would be committed, plus live files
# that `stow --adopt` would pull into the repo (a real file where the repo has one).
doctor_core_secrets() {
  section "Secrets (this repo is public)"
  local r="$DOCTOR_REPO" f n hits=""
  local pat='(api[_-]?key|token|secret|passw(or)?d)["'"'"' ]*[=:]["'"'"' ]*[A-Za-z0-9+/=|_.-]{12,}'
  while IFS= read -r f; do
    [ -f "$r/$f" ] || continue
    n=$(grep -ciE "$pat" "$r/$f" 2>/dev/null); [ "${n:-0}" -gt 0 ] && hits="$hits $f($n)"
    n=$(grep -cE '(^|[^0-9a-fA-F])[0-9]{12}([^0-9a-fA-F]|$)' "$r/$f" 2>/dev/null); [ "${n:-0}" -gt 0 ] && hits="$hits $f(12-digit:$n)"
  done < <(git -C "$r" ls-files -mo --exclude-standard 2>/dev/null)
  if [ -z "$hits" ]; then pass "nothing token- or account-ID-shaped in uncommitted files"
  else fail "uncommitted files with secret-shaped lines:$hits" "move them to an ignored file before committing"; fi
  local live=""
  for f in "$HOME/.config/fish/config.fish" "$HOME/.zshrc" "$HOME/.zshenv" "$HOME/.gitconfig"; do
    [ -f "$f" ] && [ ! -L "$f" ] || continue
    n=$(grep -ciE "$pat" "$f" 2>/dev/null); [ "${n:-0}" -gt 0 ] && live="$live ${f/#$HOME/~}($n)"
  done
  if [ -z "$live" ]; then pass "live shell configs hold no token-shaped lines"
  else warn "token-shaped lines in live configs:$live" "keep secrets out of files the repo could adopt (use an ignored secrets.fish or Keychain)"; fi
}

doctor_core_path() {
  section "PATH"
  local mode="interactive shell"; case "$-" in *i*) ;; *) mode="non-interactive shell, which is what agents and ssh commands get";; esac
  pass "$(echo "$PATH" | tr ':' '\n' | grep -c .) entries ($mode)"
}

# ---------------------------------------------------------------- runner
doctor_run_all() {
  printf '%sdoctor%s on %s (%s)\n' "$B" "$N" "$(hostname -s 2>/dev/null || hostname)" "$(uname -s)"
  doctor_core_shell; doctor_core_path; doctor_core_brew; doctor_core_repo; doctor_core_links; doctor_core_secrets
  local fn
  for fn in $(declare -F | awk '{print $3}' | grep '^doctor_check_' | sort); do "$fn"; done
  printf '\n%s✓ %d%s   %s? %d%s   %s✗ %d%s\n' "$G" "$DOCTOR_OKS" "$N" "$Y" "$DOCTOR_WARNS" "$N" "$R" "$DOCTOR_FAILS" "$N"
  [ "$DOCTOR_FAILS" -eq 0 ]
}

doctor_load_plugins() {
  local p
  for p in "$DOCTOR_D"/*.sh; do [ -f "$p" ] && . "$p"; done
}

if [ "${BASH_SOURCE[0]}" = "$0" ] || [ -n "$DOCTOR_REMOTE_CHILD" ]; then
  REMOTE=""
  while [ $# -gt 0 ]; do
    case "$1" in
      --remote) REMOTE="$2"; shift 2;;
      --fetch) DOCTOR_FETCH=1; shift;;
      -h|--help) sed -n '2,15p' "$0"; exit 0;;
      *) echo "unknown option: $1" >&2; exit 2;;
    esac
  done
  doctor_load_plugins
  if [ -n "$REMOTE" ]; then
    # Ship every function (core + plugins) and run them there with bash, so the remote
    # login shell doesn't matter. DOCTOR_REPO is resolved on the remote side.
    {
      echo 'DOCTOR_REPO="$HOME/home-directory"; DOCTOR_FAILS=0; DOCTOR_WARNS=0; DOCTOR_OKS=0'
      echo "DOCTOR_FETCH='${DOCTOR_FETCH:-}'"
      echo "DOCTOR_BREW_TOOLS='$(tr '\n' ' ' < "$DOCTOR_REPO/brew-tools.txt")'"
      echo 'if [ -t 1 ]; then :; fi; G=; R=; Y=; D=; B=; N='
      declare -f
      echo 'doctor_run_all'
    } | ssh -T -o RemoteCommand=none -o ConnectTimeout=15 "$REMOTE" 'bash -s' 2> >(grep -vE 'WARNING|decrypt later|openssh.com|may need to be|Address already|channel_setup|forwarding|listen to port' >&2)
    exit $?
  fi
  doctor_run_all
fi
