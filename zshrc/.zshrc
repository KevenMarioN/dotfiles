export ZSH="$HOME/.oh-my-zsh"

plugins=(git asdf web-search zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

export THEME_DIR=$HOME/.themes/Catppuccin-Mocha-Standard-Sapphire-Dark/
export GTK_THEME='Catppuccin-Mocha-Standard-Shapphire-Dark:dark'

# Starship
eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship.toml

# Alias
alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
alias cat="bat --style=auto"
alias cd="z"
alias n="nvim"
alias wezterm='flatpak run org.wezfurlong.wezterm'
alias letsgo="asdf exec go run ."
alias tocloud="asdf exec npm start"

# Git
alias gc="git commit -m"
alias gca="git commit -a -m"
alias gp="git push origin HEAD"
alias gpu="git pull origin"
alias gst="git status"
alias glog="git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit"
alias gdiff="git diff"
alias gco="git checkout"
alias gb='git branch'
alias gba='git branch -a'
alias gadd='git add'
alias ga='git add -p'
alias gcoall='git checkout -- .'
alias gr='git remote'
alias gre='git reset'

# Docker
alias dco="docker compose"
alias dps="docker ps"
alias dpa="docker ps -a"
alias dl="docker ps -l -q"
alias dx="docker exec -it"
alias dc="docker rm -f $(docker ps -a -q) || docker volume rm -f $(docker volume ls -q)"

# Dirs
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# Variables
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
export ANDROID_HOME=~/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH="$HOME/.tmuxifier/bin:$PATH"
export PATH="$PATH:/opt/nvim-linux64/bin"
export EDITOR="/snap/bin/nvim"

# Go
export GOPATH=$(asdf where golang)/packages
export GOROOT=$(asdf where golang)/go
export PATH=$PATH:~/go/bin

# Rust
export PATH=$HOME/.cargo/bin:$HOME/.local/bin:$PATH
export CARGO_HOME=$HOME/.cargo

# WORK ENVIRONMENT
if [ -f ~/.work_zshrc ]; then
    source ~/.work_zshrc
else
    print "404: ~/.work_zshrc not found."
fi

# ---- FZF -----
# Set up fzf key bindings and fuzzy completion
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# --- Setup FZF Theme ---
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

export FZF_DEFAULT_COMMAND="fd --hidden --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --exclude .git"
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo $'{}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "bat -n --color=always --line-range :500 {}" "$@" ;;
  esac
}

source ~/fzf-git.sh/fzf-git.sh

# ----- Bat (better cat) -----

export BAT_THEME=catppuccin_mocha

# ---- Zoxide (better cd) ----
eval "$(zoxide init zsh)"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/kevenmario/google-cloud-sdk/path.zsh.inc' ]; then . '/home/kevenmario/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/kevenmario/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/kevenmario/google-cloud-sdk/completion.zsh.inc'; fi
