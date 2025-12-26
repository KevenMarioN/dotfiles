# --- Configuration ---
ASDF_VERSION := v0.18.0
ASDF_DIR     := $(HOME)/.asdf
ASDF_BIN_DIR := $(ASDF_DIR)/bin
ASDF_COMP_DIR:= $(ASDF_DIR)/completions
ASDF_EXEC    := $(ASDF_BIN_DIR)/asdf

# Detect OS and Architecture
OS := $(shell uname -s | tr '[:upper:]' '[:lower:]')
ARCH := $(shell uname -m)

# Adjust names to match GitHub Release naming convention (x86_64 -> amd64)
ifeq ($(ARCH),x86_64)
	ARCH := amd64
endif
ifeq ($(ARCH),aarch64)
	ARCH := arm64
endif

# Download URL
DOWNLOAD_URL := https://github.com/asdf-vm/asdf/releases/download/$(ASDF_VERSION)/asdf-$(ASDF_VERSION)-$(OS)-$(ARCH).tar.gz

# --- Targets ---
.PHONY: asdf-reset asdf-install asdf-clean asdf-info install-tools install-languages install-devops asdf-all

asdf-all: asdf-install install-languages install-tools install-devops
asdf-reset: asdf-install

asdf-info:
	@echo "🖥️  System: $(OS) / $(ARCH)"
	@echo "📦 Target Version: $(ASDF_VERSION)"
	@echo "🔗 URL: $(DOWNLOAD_URL)"

asdf-install:
	@echo "🔍 Preparing installation..."
	@mkdir -p "$(ASDF_BIN_DIR)"
	@mkdir -p "$(ASDF_COMP_DIR)"

	@echo "⬇️  Downloading ASDF ($(ASDF_VERSION))..."
	@curl -L "$(DOWNLOAD_URL)" | tar xz -C "$(ASDF_BIN_DIR)"

	@echo "⚙️  Generating completions..."
	@"$(ASDF_BIN_DIR)/asdf" completion zsh > "$(ASDF_COMP_DIR)/_asdf"

	@echo "✨ ASDF Core installed."

# --- 1. Linguagens de Programação ---
install-languages:
	@echo "🏗️  Installing Languages..."

	@# Golang (Backend)
	@echo "🐹 Golang..."
	@"$(ASDF_EXEC)" plugin add golang || true
	@"$(ASDF_EXEC)" install golang latest
	@"$(ASDF_EXEC)" set -u golang latest

	@# Node.js (Frontend Svelte)
	@echo "🟢 Node.js..."
	@"$(ASDF_EXEC)" plugin add nodejs || true
	@"$(ASDF_EXEC)" install nodejs latest
	@"$(ASDF_EXEC)" set -u nodejs latest

	@# Rust (Ferramentas CLI rápidas)
	@echo "🦀 Rust..."
	@"$(ASDF_EXEC)" plugin add rust || true
	@"$(ASDF_EXEC)" install rust latest
	@"$(ASDF_EXEC)" set -u rust latest

	@# Python (Scripting/Geral)
	@echo "🐍 Python..."
	@"$(ASDF_EXEC)" plugin add python || true
	@"$(ASDF_EXEC)" install python latest
	@"$(ASDF_EXEC)" set -u python latest

# --- 2. Ferramentas Essenciais do Sistema ---
install-tools:
	@echo "🚀 Installing System Tools..."

	@# Eza (ls melhorado)
	@"$(ASDF_EXEC)" plugin add eza || true
	@"$(ASDF_EXEC)" install eza latest
	@"$(ASDF_EXEC)" set -u eza latest

	@# FZF (Fuzzy Finder - Tema Tokyo Night)
	@"$(ASDF_EXEC)" plugin add fzf || true
	@"$(ASDF_EXEC)" install fzf 0.67.0
	@"$(ASDF_EXEC)" set -u fzf 0.67.0

	@# Ripgrep (Grep rápido)
	@"$(ASDF_EXEC)" plugin add ripgrep || true
	@"$(ASDF_EXEC)" install ripgrep 15.1.0
	@"$(ASDF_EXEC)" set -u ripgrep 15.1.0

# --- 3. DevOps & Workflow ---
install-devops:
	@echo "🐳 Installing DevOps Tools..."

	@# Lazygit
	@"$(ASDF_EXEC)" plugin add lazygit https://github.com/nklmilojevic/asdf-lazygit.git || true
	@"$(ASDF_EXEC)" install lazygit latest
	@"$(ASDF_EXEC)" set -u lazygit latest

	@# Lazydocker
	@"$(ASDF_EXEC)" plugin add lazydocker https://github.com/comdotlinux/asdf-lazydocker.git || true
	@"$(ASDF_EXEC)" install lazydocker latest
	@"$(ASDF_EXEC)" set -u lazydocker latest

	@# Dive (Docker Image Explorer)
	@"$(ASDF_EXEC)" plugin add dive https://github.com/looztra/asdf-dive.git || true
	@"$(ASDF_EXEC)" install dive latest
	@"$(ASDF_EXEC)" set -u dive latest

	@echo "🎉 FULL SETUP COMPLETE!"

asdf-clean:
	@echo "🗑️  Removing ASDF..."
	@rm -rf "$(ASDF_DIR)"
	@echo "✅ Removed."
