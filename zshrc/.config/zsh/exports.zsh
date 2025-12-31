#!/bin/sh
# vim: set filetype=sh :

export KEYTIMEOUT=30
export EDITOR="nvim"
export VISUAL="nvim"
export TABSIZE=2
export SSH_TERM="xterm-256color"
export BAT_THEME="gruvbox-dark"

ZSH_HIGHLIGHT_STYLES[comment]='fg=240'
ZSH_HIGHLIGHT_STYLES[default]='fg=251'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,bold'

if command -v starship >/dev/null 2>&1; then
  export STARSHIP_CONFIG=~/.config/starship.toml
fi

if command -v bat >/dev/null 2>&1; then
  export BAT_THEME="tokyonight_night"
fi

if command -v fzf >/dev/null 2>&1; then
  export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
    --color=fg:#c0caf5,bg:#1a1b26,hl:#bb9af7 \
    --color=fg+:#c0caf5,bg+:#1a1b26,hl+:#7dcfff \
    --color=info:#7aa2f7,prompt:#7dcfff,pointer:#7dcfff \
    --color=marker:#9ece6a,spinner:#9ece6a,header:#9ece6a"
fi

# GO
export GOPRIVATE=github.com/KevenMarioN/*
