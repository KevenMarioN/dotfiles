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
    --color=fg:#ebdbb2,bg:#282828,hl:#fabd2f \
    --color=fg+:#ebdbb2,bg+:#3c3836,hl+:#fe8019 \
    --color=info:#83a598,prompt:#b8bb26,pointer:#fb4934 \
    --color=marker:#fb4934,spinner:#fabd2f,header:#83a598"
fi

# GO
export GOPRIVATE=github.com/KevenMarioN/*
