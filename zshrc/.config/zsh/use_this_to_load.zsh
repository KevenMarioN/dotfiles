#!/bin/sh
# vim: set filetype=sh :

ZSH_CONFIG_DIR="$HOME/.config/zsh"

CONFIG_CONFIG_FILE="${ZSH_CONFIG_DIR}/config.zsh"
FUNCTIONS_CONFIG_FILE="${ZSH_CONFIG_DIR}/functions.zsh"
EXPORTS_CONFIG_FILE="${ZSH_CONFIG_DIR}/exports.zsh"
ALIASES_CONFIG_FILE="${ZSH_CONFIG_DIR}/aliases.zsh"
KEYBINDS_CONFIG_FILE="${ZSH_CONFIG_DIR}/keybinds.zsh"

ZSH_CONFIG_FILES=(
  $EXPORTS_CONFIG_FILE
  $CONFIG_CONFIG_FILE
  $FUNCTIONS_CONFIG_FILE
  $ALIASES_CONFIG_FILE
  $KEYBINDS_CONFIG_FILE
)

for f in "${ZSH_CONFIG_FILES[@]}"; do
  if test -f "$f"; then
    source $f
  else
    printf "404: $f not found.\n"
  fi
done

# Exports
[[ -f ~/.env ]] && source ~/.env
