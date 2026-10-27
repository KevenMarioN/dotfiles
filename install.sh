#!/bin/bash

# Are you sure? That script is aggressive!

# Functions for printing legible colored messages.
loginfo() {
  local BLUE='\033[1;34m'
  local RESET='\033[0m'
  printf "🔵 ${BLUE}%s${RESET}\n" "$1"
}

logsuccess() {
  local GREEN='\033[1;32m'
  local RESET='\033[0m'
  printf "🟢 ${GREEN}%s${RESET}\n" "$1"
}

logerror() {
  local RED='\033[1;31m'
  local RESET='\033[0m'
  printf "🔴 ${RED}%s${RESET}\n" "$1"
}

# This command ensures that if an error occurs, the operation is interrupted.
set -e

if ! command -v apt >/dev/null 2>&1; then
  logerror "Error: ‘apt’ is not installed. Stopping the script."
  exit 1
fi

loginfo "Your system have apt, updating packages..."
sudo apt update -y
sudo add-apt-repository ppa:zhangsongcui3371/fastfetch
sudo apt upgrade -y

loginfo "Installing base development packages..."
sudo apt-get install git build-essential libssl-dev zlib1g-dev \
  libbz2-dev libreadline-dev libsqlite3-dev wget curl \
  llvm gettext tk-dev tcl-dev blt-dev libgdbm-dev \
  git python3 python3-dev aria2 xz-utils lz4 unzip liblzma-dev \
  cmake ninja-build pkg-config libtool \
  libtool-bin autoconf automake gettext curl xclip \
  -y

# --- Homebrew Installation ---
if ! command -v brew &>/dev/null; then
  loginfo "Installing Homebrew..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Configure Homebrew in current shell
if [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [ -f "$HOME/.linuxbrew/bin/brew" ]; then
  eval "$($HOME/.linuxbrew/bin/brew shellenv)"
fi

# Install via Homebrew with fallback to apt
install_brew() {
  local brew_name=$1
  local apt_name=${2:-$1}
  local cmd=${3:-$1}

  if command -v "$cmd" &>/dev/null; then
    loginfo "$cmd is already installed..."
    return
  fi

  if command -v brew &>/dev/null; then
    loginfo "Installing $cmd via Homebrew..."
    if brew list "$brew_name" &>/dev/null || brew install "$brew_name"; then
      logsuccess "✅ $cmd installed via Homebrew"
      return
    fi
  fi

  loginfo "Homebrew unavailable/failed for $cmd, falling back to apt..."
  if [ -n "$apt_name" ] && sudo apt-get install -y "$apt_name"; then
    logsuccess "✅ $cmd installed via apt"
  else
    logerror "⚠️  Could not install $cmd."
  fi
}

loginfo "Installing applications via Homebrew..."
# Terminal tools
install_brew "bat" "bat"
install_brew "eza" "eza"
install_brew "fzf" "fzf"
install_brew "htop" "htop"
install_brew "nano" "nano"
install_brew "tmux" "tmux"
install_brew "tree" "tree"
install_brew "zoxide" "zoxide"
install_brew "ripgrep" "ripgrep"
install_brew "ffmpeg" "ffmpeg"
install_brew "sqlite" "sqlite3" "sqlite3"
install_brew "p7zip" "p7zip-full" "7z"
install_brew "stow" "stow"
install_brew "vim" "vim"
install_brew "jq" "jq"
install_brew "keychain" "keychain"

# Editors / dev tools
install_brew "neovim" ""
install_brew "opencode" ""
install_brew "rtk" ""

# Neovim requirements (fzf-lua/telescope grep, LSP, formatters)
install_brew "gh" ""
install_brew "stylua" ""
install_brew "lua-language-server" "lua-language-server"

# Zsh requirements
install_brew "starship" ""

# --- apt-only packages ---
loginfo "Installing apt-only packages..."
sudo apt install -y \
  openssl fonts-jetbrains-mono kitty watch \
  xclip pkgconf fastfetch

# Install JetBrains Nerd Font (apt package if available, fallback to nerd-fonts release)
if fc-list | grep -qi "JetBrainsMonoNL Nerd Font\|JetBrainsMono Nerd Font"; then
  loginfo "JetBrains Nerd Font is already installed..."
elif sudo apt-get install -y fonts-jetbrains-mono-nerd 2>/dev/null; then
  loginfo "JetBrains Nerd Font installed via apt."
else
  loginfo "Installing JetBrains Nerd Font from nerd-fonts releases..."
  NERD_FONT_DIR="$HOME/.local/share/fonts/JetBrainsMono"
  NERD_FONT_VERSION="v3.4.0"
  curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/download/${NERD_FONT_VERSION}/JetBrainsMono.zip" \
    -o /tmp/JetBrainsMono.zip
  mkdir -p "$NERD_FONT_DIR"
  unzip -o /tmp/JetBrainsMono.zip -d "$NERD_FONT_DIR"
  rm -f /tmp/JetBrainsMono.zip
  fc-cache -f >/dev/null 2>&1 || true
fi

if ! command -v zsh &>/dev/null; then
  loginfo "Installing ZSH..."
  sudo apt install zsh -y
fi

if [ "$(getent passwd "$USER" | cut -d: -f7)" != "/usr/bin/zsh" ]; then
  loginfo "Setting ZSH as default shell..."
  chsh -s /usr/bin/zsh
else
  loginfo "ZSH has install..."
fi

if ! command -v docker &>/dev/null; then
  loginfo "Starting Install Docker"
  for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
    sudo apt-get remove -y "$pkg" || true
  done

  sudo apt-get update
  sudo apt-get install ca-certificates curl gnupg

  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  sudo chmod a+r /etc/apt/keyrings/docker.gpg

  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$UBUNTU_CODENAME") stable" |
    sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

  sudo apt-get update
  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

  sudo systemctl enable --now docker.service
  sudo systemctl enable --now containerd.service

  sudo groupadd docker 2>/dev/null || true
  sudo usermod -aG docker $USER
  loginfo "Docker installed. You may need to logout/login for group changes."
else
  loginfo "Docker has install..."
fi

if ! command -v postman &>/dev/null; then
  loginfo "Installing Postman..."
  curl -L "https://dl.pstmn.io/download/latest/linux64" -o /tmp/postman.tar.gz
  sudo tar -xzf /tmp/postman.tar.gz -C /opt
  rm -f /tmp/postman.tar.gz
  sudo ln -sf /opt/Postman/Postman /usr/bin/postman
  logsuccess "Postman installed."
else
  loginfo "Postman is already installed..."
fi

# --- Zsh e Oh My Zsh ---
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  loginfo "Installing Oh My Zsh..."
  RUNZSH=no KEEP_ZSHRC=yes /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  loginfo "Oh My Zsh has install."
fi

# Instala plugins do Zsh
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
loginfo "🔌 Instalando plugins do Zsh..."
if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM}/plugins/zsh-autosuggestions"
fi
if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"
fi
if [ ! -d "${ZSH_CUSTOM}/plugins/fzf-tab" ]; then
  git clone https://github.com/Aloxaf/fzf-tab "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab"
fi
if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-bat" ]; then
  git clone https://github.com/fdellwing/zsh-bat.git "$ZSH_CUSTOM/plugins/zsh-bat"
fi

# --- Configuração do Neovim com Lazy.nvim ---
loginfo "🐘 Configurando Neovim e Lazy.nvim..."
LAZY_PATH="$HOME/.local/share/nvim/lazy/lazy.nvim"
if [ ! -d "$LAZY_PATH" ]; then
  loginfo "Instalando o gerenciador de plugins Lazy.nvim..."
  git clone https://github.com/folke/lazy.nvim.git --filter=blob:none "$LAZY_PATH"
fi

# --- Gerenciador de Plugins do Tmux (TPM) ---
loginfo "🔄 Instalando TPM para Tmux..."
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

## ASDF
if ! command -v asdf &>/dev/null; then
  if command -v brew &>/dev/null; then
    loginfo "Installing ASDF via Homebrew..."
    brew install asdf || {
      loginfo "Homebrew failed, downloading ASDF binary from GitHub..."
      ASDF_VERSION="v0.20.0"
      OS=$(uname -s | tr '[:upper:]' '[:lower:]')
      ARCH=$(uname -m)
      if [ "$ARCH" == "x86_64" ]; then
        ARCH="amd64"
      elif [ "$ARCH" == "aarch64" ]; then
        ARCH="arm64"
      fi
      mkdir -p "$HOME/.asdf/bin"
      curl -L "https://github.com/asdf-vm/asdf/releases/download/${ASDF_VERSION}/asdf-${ASDF_VERSION}-${OS}-${ARCH}.tar.gz" |
        tar xz -C "$HOME/.asdf/bin"
    }
  else
    loginfo "Installing ASDF from GitHub..."
    ASDF_VERSION="v0.20.0"
    OS=$(uname -s | tr '[:upper:]' '[:lower:]')
    ARCH=$(uname -m)
    if [ "$ARCH" == "x86_64" ]; then
      ARCH="amd64"
    elif [ "$ARCH" == "aarch64" ]; then
      ARCH="arm64"
    fi
    mkdir -p "$HOME/.asdf/bin"
    curl -L "https://github.com/asdf-vm/asdf/releases/download/${ASDF_VERSION}/asdf-${ASDF_VERSION}-${OS}-${ARCH}.tar.gz" |
      tar xz -C "$HOME/.asdf/bin"
  fi
fi

if command -v asdf &>/dev/null || [ -x "$HOME/.asdf/bin/asdf" ]; then
  ASDF_EXEC="$(command -v asdf || echo "$HOME/.asdf/bin/asdf")"
  export ASDF_DATA_DIR="${ASDF_DATA_DIR:-$HOME/.asdf}"
  PATH="$ASDF_DATA_DIR/bin:$ASDF_DATA_DIR/shims:$PATH"

  mkdir -p "$ASDF_DATA_DIR/completions"
  "$ASDF_EXEC" completion zsh >"$ASDF_DATA_DIR/completions/_asdf"

  install_tool() {
    local name=$1
    local repo=$3

    loginfo "👉 Processando: $name..."

    if ! "$ASDF_EXEC" plugin list | grep -q "^$name$"; then
      echo "   Adicionando plugin $name..."
      if [ -n "$repo" ]; then
        "$ASDF_EXEC" plugin add "$name" "$repo"
      else
        "$ASDF_EXEC" plugin add "$name"
      fi
    fi

    if "$ASDF_EXEC" where "$name" &>/dev/null; then
      loginfo "   $name já instalado ($("$ASDF_EXEC" current "$name" 2>/dev/null))."
    else
      echo "   Instalando última versão..."
      "$ASDF_EXEC" install "$name" latest
      "$ASDF_EXEC" set -u "$name" latest
    fi

    logsuccess "✅ $name configurado."
  }

  loginfo "\n🏗️  Instalando Linguagens..."
  install_tool "golang" "" # Backend
  install_tool "nodejs" "" # Frontend Svelte
  install_tool "rust" ""   # Ferramentas CLI
  install_tool "python" "" # Scripting

  loginfo "\n🐳 Instalando Ferramentas DevOps..."
  #install_tool "lazygit" "https://github.com/nklmilojevic/asdf-lazygit.git"
  #install_tool "lazydocker" "https://github.com/comdotlinux/asdf-lazydocker.git"
  # install_tool "dive" "https://github.com/looztra/asdf-dive.git"

  "$ASDF_EXEC" reshim

  loginfo "\n🎉 FULL SETUP COMPLETE!"
  logerror "⚠️  Lembre-se de adicionar o seguinte ao seu .zshrc ou .bashrc se ainda não o fez:"
  echo 'export PATH="${HOME}/.asdf/bin:${PATH}"'
  echo 'fpath=(${HOME}/.asdf/completions $fpath)'
  echo 'autoload -Uz compinit && compinit'
fi

logsuccess "🎉 Setup complete!"
