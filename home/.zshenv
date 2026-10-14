# ~/.zshenv: read by EVERY zsh, including non-interactive `ssh host 'cmd'`,
# which never reads .zshrc and never starts fish. Keep it small and quiet:
# no output, no prompts, nothing slow.

# ~/.toolbox/bin first, so its tools win over system copies.
[ -d "$HOME/.toolbox/bin" ] && export PATH="$HOME/.toolbox/bin:$PATH"
# Linuxbrew LAST, so non-interactive builds keep the system git/python/kinit.
# (Interactive fish puts it first via `brew shellenv`; that's deliberate.)
[ -d /home/linuxbrew/.linuxbrew/bin ] && export PATH="$PATH:/home/linuxbrew/.linuxbrew/bin"

[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
[ -d "$HOME/.aim/mcp-servers" ] && export PATH="$HOME/.aim/mcp-servers:$PATH"

# Do NOT export AWS_ACCOUNT_ID here: a global default silently feeds the
# wrong account to deploy tooling. Set it per command.
export DEVELOPER_ALIAS="${DEVELOPER_ALIAS:-$USER}"
