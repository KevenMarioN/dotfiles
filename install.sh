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

loginfo "Installing apps..."
    sudo apt-get install git build-essential libssl-dev zlib1g-dev \
        libbz2-dev libreadline-dev libsqlite3-dev wget curl \
        llvm gettext tk-dev tcl-dev blt-dev libgdbm-dev \
        git python3-dev aria2 lzma liblzma-dev \
        cmake ninja-build pkg-config libtool \
        libtool-bin autoconf automake gettext curl xclip \
        -y

loginfo "Installing apps..."
    sudo apt install \
        openssl bat cmake ffmpeg fzf htop nano \
        p7zip pkgconf sqlite3 tcl tk tcl-dev tk-dev tmux \
        tree watch wget fonts-firacode fonts-jetbrains-mono vim zoxide ripgrep eza stow fastfetch \
        -y

if ! command -v nvim &> /dev/null; then
    loginfo "Compiling and Installing nvim..."
    git clone https://github.com/neovim/neovim.git ~/neovim
    cd ~/neovim
    git checkout stable
    make CMAKE_BUILD_TYPE=Release
    sudo make install
    cd build
    sudo cpack -G DEB
    sudo dpkg -i nvim-linux*.deb
    cd ~
    sudo rm -Rf ~/neovim
  else
    loginfo "Nvim já instalado..."
  fi

if ! command -v zsh &> /dev/null; then
    loginfo "Installing ZSH..."
    sudo apt install zsh -y
    chsh -s $(which zsh)
else
    loginfo "ZSH has install..."
fi

if ! command -v ghostty &> /dev/null; then
  loginfo "Installing Ghostty..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh)"
else
 loginfo "Ghostty has install..."
fi

if ! command -v docker &> /dev/null; then
  loginfo "Starting Install Docker"
  sudo apt-get remove docker docker-engine docker.io containerd runc

  sudo apt-get update
  sudo apt-get install ca-certificates curl gnupg

  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  sudo chmod a+r /etc/apt/keyrings/docker.gpg

  echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$UBUNTU_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  sudo apt-get update
  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

  sudo groupadd docker
  sudo usermod -aG docker $USER	
  newgrp docker
else
  loginfo "Docker has install..."
fi

# --- Zsh e Oh My Zsh ---
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  loginfo "Installing Oh My Zsh..."
  /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
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

if ! command -v starship >/dev/null 2>&1; then
  loginfo "Installing Starship..."
  curl -sS https://starship.rs/install.sh | sh
else
 loginfo "Startship has install"
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

if ! command -v asdf &> /dev/null; then
  loginfo "Installing ASDF..."

  # --- Configuration ---
  ASDF_VERSION="v0.18.0"
  ASDF_DIR="${HOME}/.asdf"
  ASDF_BIN_DIR="${ASDF_DIR}/bin"
  ASDF_COMP_DIR="${ASDF_DIR}/completions"
  ASDF_EXEC="${ASDF_BIN_DIR}/asdf"

  # Detect OS and Architecture
  OS=$(uname -s | tr '[:upper:]' '[:lower:]')
  ARCH=$(uname -m)

  # Adjust names to match GitHub Release naming convention
  if [ "$ARCH" == "x86_64" ]; then
      ARCH="amd64"
  elif [ "$ARCH" == "aarch64" ]; then
      ARCH="arm64"
  fi

  DOWNLOAD_URL="https://github.com/asdf-vm/asdf/releases/download/${ASDF_VERSION}/asdf-${ASDF_VERSION}-${OS}-${ARCH}.tar.gz"

  # --- Functions ---

  install_asdf_core() {
      loginfo "🖥️  System: $OS / $ARCH"
      loginfo "📦 Target Version: $ASDF_VERSION"

      if [ -f "$ASDF_EXEC" ]; then
          logerror "✅ ASDF já está instalado em $ASDF_BIN_DIR"
          return
      fi

      loginfo "🔍 Preparing installation..."
      mkdir -p "$ASDF_BIN_DIR"
      mkdir -p "$ASDF_COMP_DIR"

      loginfo "⬇️  Downloading ASDF ($ASDF_VERSION)..."
      curl -L "$DOWNLOAD_URL" | tar xz -C "$ASDF_BIN_DIR"

      loginfo "⚙️  Generating completions..."
      "$ASDF_EXEC" completion zsh > "$ASDF_COMP_DIR/_asdf"

      logsuccess "✨ ASDF Core installed."
  }

  install_tool() {
      local name=$1
      local version=$2
      local repo=$3

      loginfo "👉 Processando: $name ($version)..."

      # Adiciona o plugin
      if "$ASDF_EXEC" plugin list | grep -q "^$name$"; then
          logerror "   Plugin $name já existe."
      else
          echo "   Adicionando plugin $name..."
          if [ -n "$repo" ]; then
              "$ASDF_EXEC" plugin add "$name" "$repo"
          else
              "$ASDF_EXEC" plugin add "$name"
          fi
      fi

      # Instala a versão
      echo "   Instalando versão $version..."
      "$ASDF_EXEC" install "$name" "$version"

      # Define como global
      echo "   Definindo global..."
      "$ASDF_EXEC" set -u "$name" "$version"
      
      logsuccess "✅ $name configurado."
  }

  # --- Main Execution ---
  loginfo "🚀 Iniciando Setup do Ambiente de Desenvolvimento..."

  # 1. Instalar Core
  install_asdf_core

  export PATH="${ASDF_BIN_DIR}:${PATH}"

  loginfo "\n🏗️  Instalando Linguagens..."
  install_tool "golang" "latest"     # Backend
  install_tool "nodejs" "latest"     # Frontend Svelte
  install_tool "rust" "latest"       # Ferramentas CLI
  install_tool "python" "latest"     # Scripting

  loginfo "\n🐳 Instalando Ferramentas DevOps..."
  install_tool "lazygit" "latest" "https://github.com/nklmilojevic/asdf-lazygit.git"
  install_tool "lazydocker" "latest" "https://github.com/comdotlinux/asdf-lazydocker.git"
  # install_tool "dive" "latest" "https://github.com/looztra/asdf-dive.git"

  loginfo "\n🎉 FULL SETUP COMPLETE!"
  logerror "⚠️  Lembre-se de adicionar o seguinte ao seu .zshrc ou .bashrc se ainda não o fez:"
  echo 'export PATH="${HOME}/.asdf/bin:${PATH}"'
  echo 'fpath=(${HOME}/.asdf/completions $fpath)'
  echo 'autoload -Uz compinit && compinit'
fi
