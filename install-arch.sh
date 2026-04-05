#!/bin/bash

# Arch Linux installation script (pacman-based)
# Use at your own risk!

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

if ! command -v pacman >/dev/null 2>&1; then
  logerror "Error: 'pacman' is not installed. Stopping the script."
  exit 1
fi

loginfo "Your system has pacman, updating packages..."
sudo pacman -Syu --noconfirm

loginfo "Installing base development packages..."
sudo pacman -S --needed --noconfirm \
  base-devel git openssl bzip2 readline sqlite \
  llvm gettext tk tcl gdbm xz cmake ninja pkg-config \
  libtool autoconf automake curl wget xclip python \
  aria2 p7zip lz4 unzip --noconfirm

loginfo "Installing applications from official repos..."
sudo pacman -S --needed --noconfirm \
  bat cmake ffmpeg fzf htop nano sqlite tmux tree \
  wget vim zoxide ripgrep neovim fastfetch \
  ttf-jetbrains-mono --noconfirm

# Install eza from extra repo (or AUR if not available)
if ! command -v eza &>/dev/null; then
  loginfo "Installing eza..."
  sudo pacman -S --needed --noconfirm eza 2>/dev/null || {
    loginfo "eza not in repos, will be installed via AUR..."
  }
fi

# Install JetBrains Nerd Font (from extra repo)
if ! pacman -Qs "jetbrains-mono-nerd" &>/dev/null; then
  loginfo "Installing JetBrains Nerd Font..."
  sudo pacman -S --needed --noconfirm ttf-jetbrains-mono-nerd
fi

# --- Install yay (AUR helper) ---
if ! command -v yay &>/dev/null; then
  loginfo "Installing yay (AUR helper)..."
  git clone https://aur.archlinux.org/yay.git ~/yay
  cd ~/yay
  makepkg -si --noconfirm
  cd ~
  rm -rf ~/yay
else
  loginfo "yay is already installed..."
fi

# --- AUR Packages ---
loginfo "Installing AUR packages..."
yay -S --needed --noconfirm eza-git 2>/dev/null || true

if ! command -v zsh &>/dev/null; then
  loginfo "Installing ZSH..."
  sudo pacman -S --needed --noconfirm zsh
  chsh -s $(which zsh)
else
  loginfo "ZSH is already installed..."
fi

# if ! command -v ghostty &>/dev/null; then
#   loginfo "Installing Ghostty..."
#   yay -S --needed --noconfirm ghostty-git
# else
#   loginfo "Ghostty is already installed..."
# fi

if ! command -v docker &>/dev/null; then
  loginfo "Installing Docker..."
  sudo pacman -S --needed --noconfirm docker docker-compose docker-buildx
  
  sudo systemctl enable --now docker.service
  sudo systemctl enable --now containerd.service
  
  sudo groupadd docker 2>/dev/null || true
  sudo usermod -aG docker $USER
  loginfo "Docker installed. You may need to logout/login for group changes."
else
  loginfo "Docker is already installed..."
fi

if ! command -v bruno &>/dev/null; then
  loginfo "Installing Bruno..."
  yay -S --needed --noconfirm bruno-bin
else
  loginfo "Bruno is already installed..."
fi

# --- Zsh e Oh My Zsh ---
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  loginfo "Installing Oh My Zsh..."
  /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  loginfo "Oh My Zsh is already installed."
fi

# Install Zsh plugins
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
loginfo "Installing Zsh plugins..."
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
  loginfo "Starship is already installed"
fi

# --- Neovim with Lazy.nvim ---
loginfo "Configuring Neovim and Lazy.nvim..."
LAZY_PATH="$HOME/.local/share/nvim/lazy/lazy.nvim"
if [ ! -d "$LAZY_PATH" ]; then
  loginfo "Installing Lazy.nvim plugin manager..."
  git clone https://github.com/folke/lazy.nvim.git --filter=blob:none "$LAZY_PATH"
fi

# --- TPM for Tmux ---
loginfo "Installing TPM for Tmux..."
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

# --- ASDF ---
if ! command -v asdf &>/dev/null; then
  loginfo "Installing ASDF..."

  ASDF_VERSION="v0.18.0"
  ASDF_DIR="${HOME}/.asdf"
  ASDF_BIN_DIR="${ASDF_DIR}/bin"
  ASDF_COMP_DIR="${ASDF_DIR}/completions"
  ASDF_EXEC="${ASDF_BIN_DIR}/asdf"

  OS=$(uname -s | tr '[:upper:]' '[:lower:]')
  ARCH=$(uname -m)

  if [ "$ARCH" == "x86_64" ]; then
    ARCH="amd64"
  elif [ "$ARCH" == "aarch64" ]; then
    ARCH="arm64"
  fi

  DOWNLOAD_URL="https://github.com/asdf-vm/asdf/releases/download/${ASDF_VERSION}/asdf-${ASDF_VERSION}-${OS}-${ARCH}.tar.gz"

  install_asdf_core() {
    loginfo "🖥️  System: $OS / $ARCH"
    loginfo "📦 Target Version: $ASDF_VERSION"

    if [ -f "$ASDF_EXEC" ]; then
      logerror "✅ ASDF already installed at $ASDF_BIN_DIR"
      return
    fi

    loginfo "🔍 Preparing installation..."
    mkdir -p "$ASDF_BIN_DIR"
    mkdir -p "$ASDF_COMP_DIR"

    loginfo "⬇️  Downloading ASDF ($ASDF_VERSION)..."
    curl -L "$DOWNLOAD_URL" | tar xz -C "$ASDF_BIN_DIR"

    loginfo "⚙️  Generating completions..."
    "$ASDF_EXEC" completion zsh >"$ASDF_COMP_DIR/_asdf"

    logsuccess "✨ ASDF Core installed."
  }

  install_tool() {
    local name=$1
    local version=$2
    local repo=$3

    loginfo "👉 Processing: $name ($version)..."

    if "$ASDF_EXEC" plugin list | grep -q "^$name$"; then
      logerror "   Plugin $name already exists."
    else
      echo "   Adding plugin $name..."
      if [ -n "$repo" ]; then
        "$ASDF_EXEC" plugin add "$name" "$repo"
      else
        "$ASDF_EXEC" plugin add "$name"
      fi
    fi

    echo "   Installing version $version..."
    "$ASDF_EXEC" install "$name" "$version"

    echo "   Setting global..."
    "$ASDF_EXEC" set -u "$name" "$version"

    logsuccess "✅ $name configured."
  }

  loginfo "🚀 Starting Development Environment Setup..."

  install_asdf_core

  export PATH="${ASDF_BIN_DIR}:${PATH}"

  loginfo "\n🏗️  Installing Languages..."
  install_tool "golang" "latest"
  install_tool "nodejs" "latest"
  install_tool "rust" "latest"
  install_tool "python" "latest"

  loginfo "\n🐳 Installing DevOps Tools..."
  install_tool "lazygit" "latest" "https://github.com/nklmilojevic/asdf-lazygit.git"
  install_tool "lazydocker" "latest" "https://github.com/comdotlinux/asdf-lazydocker.git"

  loginfo "\n🎉 FULL SETUP COMPLETE!"
  logerror "⚠️  Remember to add the following to your .zshrc or .bashrc if not already done:"
  echo 'export PATH="${HOME}/.asdf/bin:${PATH}"'
  echo 'fpath=(${HOME}/.asdf/completions $fpath)'
  echo 'autoload -Uz compinit && compinit'
fi

logsuccess "🎉 Arch Linux setup complete!"