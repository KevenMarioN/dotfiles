# SSH Agent
if [ -z "$SSH_AGENT_PID" ]; then
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/personal_github # Opcional: Adiciona sua chave principal automaticamente
fi
# GPG (para commits assinados)
export GPG_TTY=$(tty)

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in zsh plugins
# Add Powerlevel10k
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found
zinit snippet OMZP::asdf
zinit snippet OMZP::docker

# Load completions
autoload -U compinit && compinit

# Paths
export PATH=$PATH:$HOME/go/bin
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

# GO
export GOPRIVATE=github.com/KevenMarioN/*

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# History
HISTSIZE=5000
HISTFILE="~/.zsh_history"
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors '${(s.:.)LS_COLORS}'
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
alias ls='ls --color'
alias nvim='nvim'
alias c=clear

# Shell Integrations
if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --zsh)"
  export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
    --color=fg:#c0caf5,bg:#1a1b26,hl:#bb9af7 \
    --color=fg+:#c0caf5,bg+:#1a1b26,hl+:#7dcfff \
    --color=info:#7aa2f7,prompt:#7dcfff,pointer:#7dcfff \
    --color=marker:#9ece6a,spinner:#9ece6a,header:#9ece6a"
fi

if [ -f "$HOME/.asdf/completions/asdf.zsh" ]; then
  . "$HOME/.asdf/completions/asdf.zsh"
fi

if [ -f "$HOME/.work_zsh" ]; then
  . "$HOME/.work_zsh"
fi

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init --cmd cd zsh)"
fi

if command -v bat >/dev/null 2>&1; then
  alias cat=bat
  export BAT_THEME="tokyonight_night"
fi

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
  export STARSHIP_CONFIG=~/.config/starship.toml
fi
