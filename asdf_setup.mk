# --- Configuration ---
ASDF_VERSION := v0.16.5
ASDF_DIR     := $(HOME)/.asdf
ASDF_BIN_DIR := $(ASDF_DIR)/bin
ASDF_COMP_DIR:= $(ASDF_DIR)/completions

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
.PHONY: asdf-reset asdf-install asdf-clean asdf-info

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

	@echo "✨ Installation Complete!"
	@echo ""
	@echo "⚠️  IMPORTANT: Update your ~/.zshrc with the block below:"
	@echo "-----------------------------------------------------"
	@echo 'export ASDF_DIR="$$HOME/.asdf"'
	@echo 'export PATH="$$ASDF_DIR/bin:$$PATH"'
	@echo ''
	@echo '# Autocomplete setup'
	@echo 'fpath=("$$ASDF_DIR/completions" $$fpath)'
	@echo 'autoload -Uz compinit && compinit'
	@echo "-----------------------------------------------------"

asdf-clean:
	@echo "🗑️  Removing ASDF..."
	@rm -rf "$(ASDF_DIR)"
	@echo "✅ Removed."
