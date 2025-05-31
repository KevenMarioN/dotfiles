EZA_VERSION := 0.21.3
EZA_ARCH := x86_64-unknown-linux-gnu
EZA_TAR := eza_$(EZA_VERSION)_$(EZA_ARCH).tar.gz
EZA_URL := https://github.com/eza-community/eza/releases/download/v$(EZA_VERSION)/$(EZA_TAR)
EZA_TMP := /tmp/eza_install

.PHONY: install-eza

install-eza:
	@echo "🔍 Verificando se 'eza' já está instalado..."
	@if command -v eza >/dev/null 2>&1; then \
		echo "✅ eza já está instalado."; \
	else \
		echo "⬇️  Baixando eza $(EZA_VERSION)..."; \
		mkdir -p $(EZA_TMP) && \
		curl -sSL -o $(EZA_TMP)/$(EZA_TAR) $(EZA_URL) && \
		tar -xzf $(EZA_TMP)/$(EZA_TAR) -C $(EZA_TMP) && \
		sudo mv $(EZA_TMP)/eza /usr/local/bin/eza && \
		rm -rf $(EZA_TMP) && \
		echo "✅ eza instalado com sucesso!"; \
	fi

