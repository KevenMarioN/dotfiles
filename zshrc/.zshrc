# ASDF - Inicialização manual antes de tudo
if [ -f "$HOME/.asdf/asdf.sh" ]; then
  . "$HOME/.asdf/asdf.sh"
fi

if [ -f "$HOME/.asdf/completions/asdf.zsh" ]; then
  . "$HOME/.asdf/completions/asdf.zsh"
fi

if [ -f "$HOME/.work_zsh" ]; then
  . "$HOME/.work_zsh"
fi

# Caminhos prioritários
#export TERM="screen-256color"
export PATH="$HOME/.asdf/shims:$PATH"
export GOBIN="$HOME/go/bin"
export PATH="$GOBIN:$PATH"
export PATH="/usr/local/go/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$(asdf where rust)/bin:$PATH"

# Starship Prompt
eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship.toml

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
plugins=(
  aws
  kubectl
  rust
  golang
  node
  pm2
  sdk
  git
  vscode
  colored-man-pages
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-interactive-cd
  asdf
)
source $ZSH/oh-my-zsh.sh

# Completions do ASDF no fpath
fpath=(${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)
autoload -Uz compinit && compinit

# Usa 'bat' no lugar do 'cat' se estiver instalado
if command -v bat >/dev/null 2>&1; then
  alias cat='bat'
fi

# Go
export GOPATH="$(asdf where golang)/packages"
export GOROOT="$(asdf where golang)/go"

# Git aliases
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

# Docker aliases
alias dco="docker compose"
alias dps="docker ps"
alias dpa="docker ps -a"
alias dl="docker ps -l -q"
alias dx="docker exec -it"
alias dc="docker rm -f $(docker ps -a -q) || docker volume rm -f $(docker volume ls -q)"

# Navegação de diretórios
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# ---- FZF -----

# Set up fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"

# -- Use fd instead of fzf --

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

# Atalhos do fzf-git.sh
[ -f "$HOME/fzf-git.sh/fzf-git.sh" ] && source "$HOME/fzf-git.sh/fzf-git.sh"

# --- setup fzf theme ---
fg="#CBE0F0"
bg="#011628"
bg_highlight="#143652"
purple="#B388FF"
blue="#06BCE4"
cyan="#2CF9ED"

export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan}"

## FZF
show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo ${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

# ----- Bat (better cat) -----
command -v bat >/dev/null && export BAT_THEME=tokyonight_night

# ---- Eza (better ls) -----
if command -v eza >/dev/null 2>&1; then
  alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"alias ls='eza --icons --group-directories-first'
fi

# thefuck alias
if command -v thefuck >/dev/null 2>&1; then
  eval $(thefuck --alias)
  eval $(thefuck --alias fk)
fi

# ---- Zoxide (better cd) ----
if command -v zoxide >/dev/null 2>&1; then
eval "$(zoxide init zsh)"
alias cd="z"
fi

# Start tmux automatic
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
  tmux new-session -A -s main
fi

# GPG (para commits assinados)
export GPG_TTY=$(tty)
