# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# HOSTNAME=`hostname`

if [ `hostname` == 'jmarcell-mbpro.local' ]; then
    alias theo="cd ~/Desktop/vagrant-test/mRVM\ Workspace/mRVM"
    alias dt="cd ~/Desktop/"
    alias nlp="cd ~/Dropbox/Cornell\ Classes/Shared\ Karan\ Jason/CS\ 4740/Final\ Project"
    alias networks="cd ~/Dropbox/Cornell\ Classes/Shared\ Garrett\ Jason\ Karan/Networks"
    alias gr="/usr/bin/growl -H localhost -m "
fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

SSH_ENV=$HOME/.ssh/environment
source ~/.bash_completion.d/git-completion.bash

export GIT_PS1_SHOWDIRTYSTATE=1
export PS1='\h:\W\[\033[01;33m\]$(__git_ps1)\[\033[00m\] \$ '
export EDITOR=emacs

function start_agent {
     echo "Initializing new SSH agent..."
     /usr/bin/ssh-agent | sed 's/^echo/#echo/' > ${SSH_ENV}
     echo succeeded
     chmod 600 ${SSH_ENV}
     . ${SSH_ENV} > /dev/null
     /usr/bin/ssh-add;
}

# Source SSH settings, if applicable

if [ -f "${SSH_ENV}" ]; then
     . ${SSH_ENV} > /dev/null
     ps -x | grep "^ *${SSH_AGENT_PID}" | grep ssh-agent$ > /dev/null || {
         start_agent;
     }
else
     start_agent;
fi