# Linguagens e ferramentas padrão do asdf
ASDF_PLUGINS := \
  golang \
  nodejs \
  python \
  lua \
  rust \
  ripgrep \
  yarn \
  deno \
	jq \
	fzf \
	bat \
	fd

# Plugins personalizados com URL (que não estão no repo principal)
ASDF_CUSTOM_PLUGINS := \
  golangci-lint=https://github.com/medipass/asdf-golangci-lint.git \
  goreleaser=https://github.com/NeoHsu/asdf-goreleaser.git \
  buf=https://github.com/asdf-community/asdf-buf.git \
  mockery=https://github.com/ryodocx/asdf-mockery.git \
  delve=https://github.com/yocalebo/asdf-delve.git \
	tmux=https://github.com/aphecetche/asdf-tmux.git \
  bat=https://github.com/asdf-community/asdf-bat.git \
	mockery=https://github.com/ryodocx/asdf-mockery.git \
  delve=https://github.com/yocalebo/asdf-delve.git \
	cargo=https://github.com/andweeb/asdf-cargo.git


apt:
	sudo apt update && sudo apt upgrade -y && \
	sudo apt install -y \
		automake \
		bison \
		build-essential \
		pkg-config \
		libevent-dev \
		libncurses5-dev \
		libncursesw5-dev \
		libutf8proc-dev \
		curl \
		git

asdf-install:
	git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.13.1

asdf-plugins:
	@echo "🚀 Instalando plugins padrão do asdf..."
	@for PLUGIN in $(ASDF_PLUGINS); do \
		echo "🔧 Instalando $$PLUGIN..."; \
		asdf plugin add $$PLUGIN 2>/dev/null || echo "✅ Plugin $$PLUGIN já instalado"; \
		asdf install $$PLUGIN latest || { echo "❌ Falha ao instalar $$PLUGIN"; continue; }; \
		asdf set -u $$PLUGIN latest || echo "⚠️ Não foi possível definir $$PLUGIN como global"; \
	done

asdf-plugins-custom:
	@echo "🛠️ Instalando plugins personalizados do asdf..."
	@for PLUGIN_URL in $(ASDF_CUSTOM_PLUGINS); do \
		NAME=$$(echo $$PLUGIN_URL | cut -d= -f1); \
		URL=$$(echo $$PLUGIN_URL | cut -d= -f2); \
		echo "🔧 Instalando $$NAME..."; \
		asdf plugin add $$NAME $$URL 2>/dev/null || echo "✅ Plugin $$NAME já instalado"; \
		asdf install $$NAME latest || { echo "❌ Falha ao instalar $$NAME"; continue; }; \
		asdf set -u $$NAME latest || echo "⚠️ Não foi possível definir $$NAME como global"; \
	done

nvim:
	curl -LO https://github.com/neovim/neovim/releases/download/v0.11.1/nvim-linux-x86_64.appimage && \
	chmod u+x nvim-linux-x86_64.appimage && \
	sudo mv nvim-linux-x86_64.appimage /usr/local/bin/nvim

go-tools:
	@echo "🔨 Instalando ferramentas Go via go install..."
	@go install golang.org/x/tools/cmd/goimports@latest
	@go install github.com/go-delve/delve/cmd/dlv@latest
	@go install golang.org/x/tools/cmd/goimports@latest
	@go install mvdan.cc/gofumpt@latest
	@go install github.com/segmentio/golines@latest
	@go install github.com/vektra/mockery/v2@latest
	@go install github.com/go-delve/delve/cmd/dlv@latest
	@go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
	@asdf reshim golang

cargo-tools:
	@echo "🔨 Instalando ferramentas Rust via cargo install..."
	@which eza >/dev/null 2>&1 && echo "✅ eza já instalado" || \
		(cargo install eza && echo "✅ eza instalado com sucesso" || echo "❌ Falha ao instalar eza")
	@which tlrc >/dev/null 2>&1 && echo "✅ tlrc já instalado" || \
		(cargo install tlrc --version 1.10.0 && echo "✅ tlrc instalado com sucesso (v1.10.0)" || echo "❌ Falha ao instalar tlrc (use versão mais antiga ou corrija dependências)")
	@which zoxide >/dev/null 2>&1 && echo "✅ zoxide já instalado" || \
		(cargo install zoxide && echo "✅ zoxide instalado com sucesso" || echo "❌ Falha ao instalar zoxide")
	@asdf reshim rust 

python-tools:
	@echo "🔨 Instalando ferramentas Python via npm install..."
	@pip install thefuck --user

setup: apt asdf-install asdf-langs asdf-custom nvim cargo-tools python-tools
