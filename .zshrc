export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="$HOME/.bun/bin:$PATH"

export PATH=$HOME/.composer/vendor/bin:$PATH
# export JAVA_HOME=`/usr/libexec/java_home -v 1.8`
export HISTCONTROL=ignoreboth
export HISTFILESIZE=10000
# Machine-local secrets (OPENAI_API_KEY etc.) live in ~/.zshrc.local (untracked)
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"



HISTIGNORE='?:??:???:exit'
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE

setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_NO_STORE

alias windsurf='windsurf-next'
alias vim='nvim'
alias rcssh='ec2sshtb'
alias be='bundle exec'
alias dc='docker compose'
alias python='python3'
alias pip='pip3'
export EDITOR=vim
eval "$(direnv hook zsh)"
# for using ctrl+e bind
bindkey -e

export PATH="$GOPATH/bin:$PATH"



export DOCKER_DEFAULT_PLATFORM=linux/amd64

# for lima
# export DOCKER_HOST=unix://$HOME/docker.sock


if [[ ! -d ~/.zplug ]];then
  git clone https://github.com/zplug/zplug ~/.zplug
fi

source ~/.zplug/init.zsh
source ~/.zplug/per-directory-history.zsh

# enhancd config
export ENHANCD_COMMAND=ed
export ENHANCD_FILTER=ENHANCD_FILTER=fzy:fzf:peco

# Vanilla shell
zplug "yous/vanilli.sh"

# Additional completion definitions for Zsh
zplug "zsh-users/zsh-completions"

# Load the theme.
# zplug "yous/lime"
zplug mafredri/zsh-async, from:github, at:ee1d11b
zplug sindresorhus/pure, use:pure.zsh, from:github, as:theme, at:2f13dea

# Syntax highlighting bundle. zsh-syntax-highlighting must be loaded after
# excuting compinit command and sourcing other plugins.
zplug "zsh-users/zsh-syntax-highlighting", defer:2, at:754cefe

# ZSH port of Fish shell's history search feature
zplug "zsh-users/zsh-history-substring-search", defer:2, at:400e58a

# Tracks your most used directories, based on 'frecency'.
zplug "rupa/z", use:"*.sh"

# A next-generation cd command with an interactive filter
zplug "b4b4r07/enhancd", use:init.sh

# This plugin adds many useful aliases and functions.
zplug "plugins/git",   from:oh-my-zsh

# Install plugins if there are plugins that have not been installed
# (auto-install so a fresh machine gets the theme / syntax-highlighting on first run)
if ! zplug check; then
    zplug install
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


# Set PATH for GAE
# export PATH=$HOME/go/appengine:$PATH

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

function peco-branch () {
    git branch | peco | xargs git co
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
eval "$(pyenv init --path)"
export PATH="/usr/local/opt/openssl/bin:$PATH"
export PATH="/usr/local/opt/mysql@5.6/bin:$PATH"
export PATH="/opt/homebrew/opt/git/bin:$PATH"
export PATH="$HOME/.nodenv/bin:$PATH"

alias hubmdpr="hub -c core.commentChar='%' pull-request"
# Source chtf
if [[ -f /usr/local/share/chtf/chtf.sh ]]; then
    source "/usr/local/share/chtf/chtf.sh"
fi

export DOCKER_BUILDKIT=1
export TF_CLI_ARGS_plan="--parallelism=30"

# for eksctl
# fpath=($fpath ~/.zsh/completion)
# export PATH="$HOME/.cargo/bin:$PATH"
# 
# alias ks='kubectl'

# kss() {
#   ks config get-contexts | sed "/^\ /d"
#   ks auth can-i get ns >/dev/null 2>&1 && echo "(Authorized)" || echo "(Unauthorized)"
# }

#  kc() {
#    test "$1" = "-" && kubectx - || kubectx "$(kubectx | peco)"
#  }
#  
#  kn() {
#    test "$1" = "-" && kubens - || kubens "$(kubens | peco)"
#  }


# The next line updates PATH for the Google Cloud SDK.
# if [ -f '/Users/reizist/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/reizist/google-cloud-sdk/path.zsh.inc'; fi
 
# The next line enables shell command completion for gcloud.
if [ -f '/Users/reizist/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/reizist/google-cloud-sdk/completion.zsh.inc'; fi
eval "$(nodenv init -)"
# eval "$(zellij setup --generate-auto-start zsh)"


# bun completions
[ -s "/Users/kainumareiji/.bun/_bun" ] && source "/Users/kainumareiji/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# export PYENV_ROOT="$HOME/.pyenv"
# export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init -)"

export PATH=$HOME/.rill:$PATH # Added by Rill install

. "$HOME/.local/bin/env"
eval "$(uv generate-shell-completion zsh)"

# Added by Windsurf
export PATH="/Users/kainumareiji/.codeium/windsurf/bin:$PATH"
# Added by Windsurf - Next
export PATH="/Users/kainumareiji/.codeium/windsurf/bin:$PATH"

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"
