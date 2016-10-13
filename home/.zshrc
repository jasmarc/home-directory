# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=/Users/jason/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="robbyrussell"
ZSH_THEME="bullet-train/bullet-train"

ZSH_THEME="bullet-train/bullet-train"
BULLETTRAIN_PROMPT_ORDER=(
    status
    context
    virtualenv
    dir
    git
)

# STATUS
BULLETTRAIN_STATUS_EXIT_SHOW=true
BULLETTRAIN_STATUS_BG=black
BULLETTRAIN_STATUS_ERROR_BG=red
BULLETTRAIN_STATUS_FG=black

# PROMPT
BULLETTRAIN_PROMPT_CHAR=""              # Character to be show before any cmd
BULLETTRAIN_PROMPT_ROOT=false           # Highlight if running as root
BULLETTRAIN_PROMPT_SEPARATE_LINE=false  # Make the prompt span across two lines
BULLETTRAIN_PROMPT_ADD_NEWLINE=false    # Adds a \n before each prompt line

# Dir
BULLETTRAIN_DIR_BG=blue
BULLETTRAIN_DIR_FG=black
BULLETTRAIN_DIR_CONTEXT_SHOW=false
BULLETTRAIN_DIR_EXTENDED=0

# Git
BULLETTRAIN_GIT_COLORIZE_DIRTY=true
BULLETTRAIN_GIT_COLORIZE_DIRTY_BG_COLOR=yellow
BULLETTRAIN_GIT_COLORIZE_DIRTY_FG_COLOR=black
BULLETTRAIN_GIT_BG=green
BULLETTRAIN_GIT_FG=black
BULLETTRAIN_GIT_DIRTY=""
BULLETTRAIN_GIT_CLEAN=""
BULLETTRAIN_GIT_ADDED=" \UE168"     # 
BULLETTRAIN_GIT_MODIFIED=" \UE17C"  # 
BULLETTRAIN_GIT_DELETED=" \UE16A"   # 
BULLETTRAIN_GIT_UNTRACKED=" \UE16C" # 
BULLETTRAIN_GIT_RENAMED=" \UE1B7"   # 
BULLETTRAIN_GIT_UNMERGED=" ="
BULLETTRAIN_GIT_AHEAD=" \UE1B8"     # 
BULLETTRAIN_GIT_BEHIND=" \UE1B9"    # 
BULLETTRAIN_GIT_DIVERGED=" \UE1EA"  # 

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

export EDITOR=emacs
export SVN_LOG_EDITOR=$EDITOR
export REAL_NAME="Jason Marcell"
export EMAIL_ADDRESS="jmarcell@apple.com"
export PATH=/usr/local/bin:/usr/local/sbin:$PATH

if [ -d ~/bin ]; then
  PATH=~/bin:$PATH
fi

alias tower=gittower
alias g=git
alias how=howdoi

# Source all dotfiles under ~/.include
D="$HOME/.include"
if [ -e $D ]; then
    for f in $(find $D -type f); do
        . $f
    done
fi
