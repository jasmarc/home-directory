# If not running interactively, don't do anything
[ -z "$PS1" ] && return

if [ -d ~/bin ] ; then
   PATH=~/bin:"${PATH}"
fi
if [ -d ~/usr/bin ] ; then
   PATH=~/usr/bin:"${PATH}"
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# This is so that we can do forward history search
stty stop ^J

SSH_ENV=$HOME/.ssh/environment

source ~/.bash_completion.d/git-completion.bash
source ~/.bash_completion.d/git-flow-completion.bash

__git_ps1() {
    laststat=$?
    gitpath=`which git`
    status=`$gitpath status 2> /dev/null`
    mystat=""
    `echo "$status" | grep "Your branch is behind" > /dev/null 2>&1`
    [[ $? == 0 ]] && mystat=" ↓"
    `echo "$status" | grep "Your branch is ahead" > /dev/null 2>&1`
    [[ $? == 0 ]] && mystat=" ↑"
    `echo "$status" | grep "have diverged" > /dev/null 2>&1`
    [[ $? == 0 ]] && mystat=" ↕"
    [[ $(echo "$status" | tail -n1) =~ "working directory clean" ]] || mystat=" *"
    $gitpath branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/ (\1$mystat)/"
    return $laststat
}

__svn_ps1() {
  export dirty=`parse_svn_dirty`
  parse_svn_url | sed -E 's#^.*(trunk|branches/.+).*#\1#' | \
      sed -E 's#branches/##' | awk -F '/' '{print " ("$1"" ENVIRON["dirty"] ")" }'
}
parse_svn_url() {
  svn info 2>/dev/null | sed -ne 's#^URL: ##p'
}
parse_svn_dirty() {
  if [ $((`svn status 2>/dev/null | wc -l`)) -gt 0 ]; then echo " *"; fi
}

NONE="\[\033[0m\]"    # unsets color to term's fg color

# regular colors
K="\[\033[0;30m\]"    # black
R="\[\033[0;31m\]"    # red
G="\[\033[0;32m\]"    # green
Y="\[\033[0;33m\]"    # yellow
B="\[\033[0;34m\]"    # blue
M="\[\033[0;35m\]"    # magenta
C="\[\033[0;36m\]"    # cyan
W="\[\033[0;37m\]"    # white
SCM='$(__git_ps1)$(__svn_ps1)'

export GIT_PS1_SHOWDIRTYSTATE=1
export PS1="$G\h$W:$M\W$Y$SCM$NONE \$ "

export EDITOR=emacs
export CLICOLOR=true
export LSCOLORS="HxfxcxdxBxegedabagacHx"

pkg-install()
{
    sudo installer -pkg "$1" -target "/"
}

alias eject-usb="diskutil eject"
alias mount-dmg="hdiutil attach"
alias eject-dmg="hdiutil eject"
alias g=git

function itunes-pause () {
    /usr/bin/osascript -e 'tell application "iTunes"' -e "pause" -e "end tell"
}

function mute () {
    /usr/bin/osascript -e 'set volume 0'
}

PATH=/usr/local/bin:/usr/local/sbin:$PATH

# Source all dotfiles under ~/.include
D="$HOME/.include"; if [ -e $D ]; then for f in `find $D -type f`; do . $f; done; fi

icloud-ssh()
{
    ssh -2 -6 $1.$ICLOUDID.members.btmm.icloud.com
}
