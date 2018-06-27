# Path to the oh-my-zsh installation.
export ZSH=/home/REPLACE_USER/.oh-my-zsh

bindkey '^H' backward-kill-word

# ZSH settings
ZSH_THEME="spaceship"
DEFAULT_USER=NOTTHIS
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
ENABLE_CORRECTION="false"
DISABLE_AUTO_UPDATE="false"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=7'

# Plugins
plugins=(git command-not-found common-aliases zsh-autosuggestions zsh-syntax-highlighting docker django pip)

# Settings
export DISABLE_UPDATE_PROMPT=true
export LANG=en_US.UTF-8
export EDITOR='vim'
export GIT_EDITOR='vim'
export ECTO_EDITOR=$EDITOR
export SSH_KEY_PATH='~/.ssh/rsa_id'
export GPG_TTY=$(tty)

# Functions
function lazygit() {
        git add .
        git commit -S -a -m "$1"
        git push
}

function copy() {
        xclip -sel clip < "$1"
}

function up() {
        sudo apt update
        sudo apt upgrade
        sudo apt autoremove
        sudo apt clean
}

# Aliases
alias PATH='echo $PATH | tr ":" "\n" | sort | nl'
alias r='trash-put'
alias freespace='ncdu'
alias s='sudo systemctl'

# ZSH cache
ZSH_CACHE_DIR=$HOME/.cache/oh-my-zsh
if [[ ! -d $ZSH_CACHE_DIR ]]; then
        mkdir $ZSH_CACHE_DIR
fi


# Load oh-my-zsh
source $ZSH/oh-my-zsh.sh
fpath=($fpath "/home/REPLACE_USER/.zfunctions")

# Set Spaceship ZSH as a prompt
autoload -U promptinit; promptinit
fpath=($fpath "/home/REPLACE_USER/.zfunctions")

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
