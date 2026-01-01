#!/bin/sh
# vim: set filetype=sh :

# Reset
RESET='\033[0m'

# Cores normais
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'

# Funções para printar mensagens coloridas de forma legível
log() {
  printf "${CYAN}%s${RESET}\n" "$1"
}

loginfo() {
  log "🔵 $1"
}

logsuccess() {
  printf "🟢 ${GREEN}%s${RESET}\n" "$1"
}

logwarning() {
  printf "🟡 ${YELLOW}%s${RESET}\n" "$1"
}

logerror() {
  printf "🔴 ${RED}%s${RESET}\n" "$1"
}

dtouch() {
  mkdir -p "$(dirname "$1")"
  touch "$1"
}
