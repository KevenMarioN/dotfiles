#!/bin/sh
# vim: set filetype=sh :

alias zs='source ~/.zshrc'
alias ls='ls --color'
alias nvim='nvim'
alias c=clear

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init --cmd cd zsh)"
fi

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

if command -v batcat >/dev/null 2>&1; then
  alias cat=batcat
fi

if command -v eza >/dev/null 2>&1; then
  alias ls='eza --icons'
  alias ll='eza -l --icons --git --group-directories-first'
  alias la='eza -la --icons --git --group-directories-first'
  alias tree='eza --tree --icons'
fi