#!/bin/sh
# vim: set filetype=sh :

source "${HOME}/.config/zsh/use_this_to_load.zsh"
test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
