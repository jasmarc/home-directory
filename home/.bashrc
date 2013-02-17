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

SSH_ENV=$HOME/.ssh/environment
source ~/.bash_completion.d/git-completion.bash

# This is so that we can do forward history search
stty stop ^J

export GIT_PS1_SHOWDIRTYSTATE=1
export PS1='\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;35m\]\W\[\033[01;33m\]$(__git_ps1)\[\033[00m\] \$ '
export EDITOR=emacs

pkg-install()
{
    sudo installer -pkg "$1" -target "/"   
}

alias eject-usb="diskutil eject"
alias mount-dmg="hdiutil attach"
alias eject-dmg="hdiutil eject"

PATH=/usr/local/bin:/usr/local/sbin:$PATH
