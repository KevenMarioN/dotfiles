#!/bin/bash

# Void Linux installation script (xbps-based) with Homebrew priority
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

# Function to install via xbps safely (no error if already installed)
install_via_xbps() {
  local packages="$@"
  loginfo "Installing via xbps: $packages"
  sudo xbps-install -S $packages -y 2>/dev/null || {
    # If bulk install fails, try individual packages
    for pkg in $packages; do
      if xbps-query $pkg >/dev/null 2>&1; then
        loginfo "$pkg is already installed via xbps"
      else
        loginfo "Installing $pkg..."
        sudo xbps-install -S $pkg -y || true
      fi
    done
  }
}

# Verify Void Linux
if ! command -v xbps-install >/dev/null 2>&1; then
  logerror "Error: 'xbps-install' is not installed. This script is for Void Linux only."
  exit 1
fi

loginfo "Void Linux detected. Checking sudo access..."
sudo -v

loginfo "Updating system..."
sudo xbps-install -Su || true

# --- Homebrew Installation ---
if ! command -v brew &>/dev/null; then
  loginfo "Installing Homebrew..."

  # Install Homebrew dependencies via xbps
  install_via_xbps curl file git procps-ng

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Configure Homebrew in current shell
  if [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
  elif [ -f ~/.linuxbrew/bin/brew ]; then
    eval "$(~/.linuxbrew/bin/brew shellenv)"
    export HOMEBREW_PREFIX="$HOME/.linuxbrew"
  fi

  logsuccess "Homebrew installed successfully!"
else
  loginfo "Homebrew is already installed..."

  # Get Homebrew prefix
  if [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
    export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
  elif [ -f ~/.linuxbrew/bin/brew ]; then
    export HOMEBREW_PREFIX="$HOME/.linuxbrew"
  else
    export HOMEBREW_PREFIX="$(brew --prefix)"
  fi
fi

# --- Essential System Packages (xbps) ---
loginfo "Installing essential system packages via xbps..."
install_via_xbps base-devel git openssl bzip2 readline sqlite3 xz zlib \
  llvm gettext tk tcl gdbm htop file procps-ng

# --- CLI Applications via Homebrew ---
loginfo "Installing CLI applications via Homebrew..."

# Function to install via Homebrew with fallback to xbps
install_via_brew() {
  local app=$1
  local xbps_name=$2
  local brew_name=${3:-$app}

  if ! command -v $app &>/dev/null; then
    loginfo "Installing $app via Homebrew..."
    if brew install $brew_name 2>/dev/null; then
      logsuccess "✅ $app installed via Homebrew"
    else
      loginfo "Homebrew failed for $app, trying xbps..."
      if [ -n "$xbps_name" ]; then
        install_via_xbps $xbps_name
        logsuccess "✅ $app installed via xbps"
      else
        install_via_xbps $app
        logsuccess "✅ $app installed via xbps"
      fi
    fi
  else
    loginfo "$app is already installed..."
  fi
}

# Priority applications via Homebrew
install_via_brew "neovim" "neovim"
install_via_brew "tmux" "tmux"
install_via_brew "bat" "bat"
install_via_brew "eza" "eza"
install_via_brew "ripgrep" "ripgrep"
install_via_brew "fzf" "fzf"
install_via_brew "zoxide" "zoxide"
install_via_brew "fastfetch" "fastfetch"
install_via_brew "tree" "tree"

# --- Database Tools ---
loginfo "Installing database tools..."

# DBeaver via xbps (not available in Homebrew)
if ! command -v dbeaver &>/dev/null; then
  loginfo "Installing DBeaver via xbps..."
  install_via_xbps dbeaver openjdk17
else
  loginfo "DBeaver is already installed..."
fi

# PostgreSQL via Homebrew
if ! command -v psql &>/dev/null; then
  loginfo "Installing PostgreSQL client via Homebrew..."
  brew install postgresql
else
  loginfo "PostgreSQL client is already installed..."
fi

# MySQL/MariaDB via Homebrew
if ! command -v mysql &>/dev/null; then
  loginfo "Installing MariaDB client via Homebrew..."
  brew install mariadb
else
  loginfo "MySQL/MariaDB client is already installed..."
fi
# SQLite CLI tools via xbps (verificar antes)
if ! command -v pgcli &>/dev/null; then
  loginfo "Installing pgcli via xbps..."
  install_via_xbps pgcli
else
  loginfo "pgcli is already installed..."
fi

if ! command -v litecli &>/dev/null; then
  loginfo "Installing litecli via xbps..."
  install_via_xbps litecli
else
  loginfo "litecli is already installed..."
fi

# --- Docker via Homebrew ---
loginfo "Installing Docker via Homebrew..."
if ! command -v docker &>/dev/null; then
  brew install docker docker-compose
  sudo usermod -aG docker $USER 2>/dev/null || loginfo "Note: You may need to add yourself to docker group manually"
  loginfo "To start docker service: sudo ln -s /etc/sv/docker /var/service/"
else
  loginfo "Docker is already installed..."
fi

# --- Flatpak ---
loginfo "Installing Flatpak..."
install_via_xbps flatpak
if ! flatpak remote-list | grep -q flathub; then
  loginfo "Configuring Flatpak Flathub repository..."
  sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
fi

# --- Kitty via Homebrew ---
if ! command -v kitty &>/dev/null; then
  loginfo "Installing Kitty terminal via Homebrew..."
  brew install kitty
else
  loginfo "Kitty is already installed..."
fi

# --- Nerd Fonts via Homebrew Casks ---
loginfo "Installing Nerd Fonts via Homebrew..."
brew install --cask font-jetbrains-mono-nerd-font
brew install --cask font-fira-code-nerd-font

# --- Postman via Flatpak ---
if ! command -v postman &>/dev/null; then
  loginfo "Installing Postman via Flatpak..."
  flatpak install flathub com.getpostman.Postman -y
else
  loginfo "Postman is already installed..."
fi

# --- Zsh and Oh My Zsh ---
if ! command -v zsh &>/dev/null; then
  loginfo "Installing ZSH..."
  install_via_xbps zsh
  chsh -s $(which zsh)
else
  loginfo "ZSH is already installed..."
fi

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

# --- Starship ---
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

# --- ASDF via Homebrew ---
if ! command -v asdf &>/dev/null; then
  loginfo "Installing ASDF via Homebrew..."
  brew install asdf
else
  loginfo "ASDF is already installed..."
fi

# Configure ASDF in current shell
if [ -f "$HOMEBREW_PREFIX/opt/asdf/libexec/asdf.sh" ]; then
  . "$HOMEBREW_PREFIX/opt/asdf/libexec/asdf.sh"
fi

if command -v asdf &>/dev/null; then
  loginfo "🚀 Starting Development Environment Setup..."

  install_tool() {
    local name=$1
    local version=$2
    local repo=$3

    loginfo "👉 Processing: $name ($version)..."

    if asdf plugin list | grep -q "^$name$"; then
      logerror "   Plugin $name already exists."
    else
      echo "   Adding plugin $name..."
      if [ -n "$repo" ]; then
        asdf plugin add "$name" "$repo"
      else
        asdf plugin add "$name"
      fi
    fi

    echo "   Installing version $version..."
    asdf install "$name" "$version"

    echo "   Setting global..."
    asdf set -u "$name" "$version"

    logsuccess "✅ $name configured."
  }

  loginfo "\n🏗️  Installing Languages..."
  install_tool "golang" "latest"
  install_tool "nodejs" "latest"
  install_tool "rust" "latest"
#  install_tool "python" "latest"

  loginfo "\n🐳 Installing DevOps Tools..."
  install_tool "lazygit" "latest" "https://github.com/nklmilojevic/asdf-lazygit.git"
  install_tool "lazydocker" "latest" "https://github.com/comdotlinux/asdf-lazydocker.git"

  loginfo "\n🎉 ASDF setup complete!"
  logerror "⚠️  Remember to add the following to your .zshrc if not already done:"
  echo 'export PATH="$HOMEBREW_PREFIX/opt/asdf/libexec/bin:$PATH"'
  echo '. "$HOMEBREW_PREFIX/opt/asdf/libexec/asdf.sh"'
fi

# --- Build Tools via Homebrew ---
loginfo "Installing build tools via Homebrew..."
brew install cmake ninja pkg-config autoconf automake libtool

logsuccess "🎉 Void Linux setup with Homebrew priority complete!"
loginfo "Next steps:"
loginfo "1. Logout and login again for group changes to take effect"
loginfo "2. Start docker service: sudo ln -s /etc/sv/docker /var/service/"
loginfo "3. Configure your shell in ~/.zshrc:"
loginfo "   - Homebrew: eval \"\$($HOMEBREW_PREFIX/bin/brew shellenv)\""
loginfo "   - ASDF: . \"$HOMEBREW_PREFIX/opt/asdf/libexec/asdf.sh\""
loginfo "4. Reload shell: exec zsh"
