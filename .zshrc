export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH=$HOME/.composer/vendor/bin:$PATH
export JAVA_HOME=`/usr/libexec/java_home -v 1.8`

eval $(dinghy env)

alias vim='nvim'
alias be='bundle exec'
export EDITOR=vim
eval "$(direnv hook zsh)"
# for using ctrl+e bind
bindkey -e

export PATH=$HOME/.nodebrew/current/bin:$PATH
export GOPATH="$HOME/.go"
export PATH="$GOPATH/bin:$PATH"


if [[ ! -d ~/.zplug ]];then
  git clone https://github.com/zplug/zplug ~/.zplug
fi

source ~/.zplug/init.zsh

# enhancd config
export ENHANCD_COMMAND=ed
export ENHANCD_FILTER=ENHANCD_FILTER=fzy:fzf:peco

# Vanilla shell
zplug "yous/vanilli.sh"

# Additional completion definitions for Zsh
zplug "zsh-users/zsh-completions"

# Load the theme.
zplug "yous/lime"

# Syntax highlighting bundle. zsh-syntax-highlighting must be loaded after
# excuting compinit command and sourcing other plugins.
zplug "zsh-users/zsh-syntax-highlighting", defer:2

# ZSH port of Fish shell's history search feature
zplug "zsh-users/zsh-history-substring-search", defer:2

# Tracks your most used directories, based on 'frecency'.
zplug "rupa/z", use:"*.sh"

# A next-generation cd command with an interactive filter
zplug "b4b4r07/enhancd", use:init.sh

# This plugin adds many useful aliases and functions.
zplug "plugins/git",   from:oh-my-zsh

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load --verbose

# Lime theme settings
export LIME_DIR_DISPLAY_COMPONENTS=2

# Better history searching with arrow keys
if zplug check "zsh-users/zsh-history-substring-search"; then
    bindkey "$terminfo[kcuu1]" history-substring-search-up
    bindkey "$terminfo[kcud1]" history-substring-search-down
fi

# Add color to ls command
export CLICOLOR=1

# NeoVim config
export XDG_CONFIG_HOME=$HOME/.config

# Load rbenv
if [ -e "$HOME/.rbenv" ]; then
  eval "$(rbenv init - zsh)"
fi

# Set GOPATH for Go
if command -v go &> /dev/null; then
  [ -d "$HOME/go" ] || mkdir "$HOME/go"
  export GOPATH="$HOME/go"
  export GOROOT=/usr/local/opt/go/libexec
  export PATH="$PATH:$GOPATH/bin:$GOROOT/bin"
fi

# Set PATH for GAE
export PATH=$HOME/go/appengine:$PATH

function peco-src () {
  local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-src
bindkey '^]' peco-src

function peco-cd()
{
    local var
    local dir
    if [ ! -t 0 ]; then
    var=$(cat -)
    dir=$(echo -n $var | peco)
    else
        return 1
    fi

    if [ -d "$dir" ]; then
        cd "$dir"
    else
        echo "'$dir' was not directory." >&2
        return 1
    fi
}

alias pecocd='find . | peco-cd'

function peco-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(history -n 1 | \
        eval $tac | \
        peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}

function peco-kill-process () {
    ps -ef | peco | awk '{ print $2 }' | xargs kill
    zle clear-screen
}
zle -N peco-kill-process
bindkey '^[' peco-kill-process   # C-k
function gim() {
    vim `git ls-files | peco`
}

zle -N peco-select-history
bindkey '^r' peco-select-history
export PYENV_ROOT="${HOME}/.pyenv"
export PATH="${PYENV_ROOT}/bin:$PATH"
eval "$(pyenv init -)"
export PATH="$PYENV_ROOT/versions/anaconda3-4.2.0/bin/:$PATH"
export PATH="/usr/local/opt/openssl/bin:$PATH"
export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib/native"
export HADOOP_HOME="/usr/local/Cellar/hadoop/2.8.2"
export HADOOP_CONF_DIR="$HADOOP_HOME/libexec/etc/hadoop"
export HIVE_HOME="/usr/local/Cellar/hive/2.3.1"
export HIVE_CONF_DIR="$HIVE_HOME/libexec/conf"