# If not running interactively, don't do anything
[ -z "$PS1" ] && return

if [ -d ~/bin ] ; then
   PATH=~/bin:"${PATH}"
fi
if [ -d ~/usr/bin ] ; then
   PATH=~/usr/bin:"${PATH}"
fi

if [ `hostname` == 'jmarcell-mbpro' ]; then
    alias theo="cd ~/Desktop/vagrant-test/mRVM\ Workspace/mRVM"
    alias dt="cd ~/Desktop/"
    alias nlp="cd ~/Dropbox/Cornell\ Classes/Shared\ Karan\ Jason/CS\ 4740/Final\ Project"
    alias networks="cd ~/Dropbox/Cornell\ Classes/Shared\ Garrett\ Jason\ Karan/Networks"
    alias gr="/usr/bin/growl -H localhost -m "
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

SSH_ENV=$HOME/.ssh/environment
source ~/.bash_completion.d/git-completion.bash

export GIT_PS1_SHOWDIRTYSTATE=1
export PS1='\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;35m\]\W\[\033[01;33m\]$(__git_ps1)\[\033[00m\] \$ '
export EDITOR=emacs

function start_agent {
     echo "Initializing new SSH agent..."
     /usr/bin/ssh-agent | sed 's/^echo/#echo/' > ${SSH_ENV}
     echo succeeded
     chmod 600 ${SSH_ENV}
     . ${SSH_ENV} > /dev/null
     /usr/bin/ssh-add;
}