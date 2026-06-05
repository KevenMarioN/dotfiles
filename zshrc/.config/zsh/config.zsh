#!/bin/sh
# vim: set filetype=sh :

SAVEHIST=1000000 # Thats way too big, but I'm testing something
HISTSIZE=1000000

setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt APPEND_HISTORY            # Append to the history.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.

setopt AUTO_CD                   # cd by typing directory name if it's not a command.
setopt AUTO_LIST                 # Automatically list choices on ambiguous completion.
setopt AUTO_MENU                 # Automatically use menu completion.
setopt ALWAYS_TO_END             # Move cursor to end if word had one match.

setopt AUTO_PUSHD                # Make cd behave like pushd adding directories to the stack.
setopt PUSHD_IGNORE_DUPS         # Don't add duplicate directories to the stack.
setopt PUSHD_SILENT              # Suppress printing the directory stack when using pushd/popd.

setopt NONOMATCH                 # Don't throw errors when a glob pattern doesn't match anything.
setopt EXTENDED_GLOB             # Enable advanced glob operators.
setopt GLOB_DOTS                 # Include dotfiles when globbing.

# I HATE THESE
# setopt CORRECT_ALL               # Autocorrect commands.
# setopt CORRECT                   # Light command correction.

export ASDF_DIR="$HOME/.asdf"
if [ -d "$ASDF_DIR" ]; then
  export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
  fpath=("$ASDF_DIR/completions" $fpath)
  autoload -Uz compinit && compinit
fi

if  command -v keychain >/dev/null 2>&1; then
  eval $(keychain --eval --quiet personal)
else
  if [ -z "$SSH_AUTH_SOCK" ]; then
    eval $(ssh-agent -s) > /dev/null
    ssh-add ~/.ssh/personal# Opcional: Adiciona sua chave principal automaticamente
  fi
fi

# GPG (para commits assinados)
export GPG_TTY=$(tty)

# .zshrc
export ZSH="$HOME/.oh-my-zsh"
plugins=(asdf git fzf zsh-autosuggestions zsh-syntax-highlighting fzf-tab zsh-bat)
source $ZSH/oh-my-zsh.sh

if [ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]; then
  source /usr/share/doc/fzf/examples/key-bindings.zsh
fi

# # Carrega o autocompletar (ex: kill <TAB>, ssh <TAB>)
# if [ -f /usr/share/doc/fzf/examples/completion.zsh ]; then
#   source /usr/share/doc/fzf/examples/completion.zsh
# fi



# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors '${(s.:.)LS_COLORS}'
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
