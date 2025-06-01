LAZYGIT_VERSION := 0.42.0
LAZYGIT_TAR := lazygit_$(LAZYGIT_VERSION)_Linux_x86_64.tar.gz
LAZYGIT_URL := https://github.com/jesseduffield/lazygit/releases/download/v$(LAZYGIT_VERSION)/$(LAZYGIT_TAR)
LOCAL_BIN := $(HOME)/.local/bin

install-lazygit:
	@echo "📦 Instalando lazygit v$(LAZYGIT_VERSION)..."
	@mkdir -p $(LOCAL_BIN)
	@curl -Lo $(LAZYGIT_TAR) $(LAZYGIT_URL)
	@tar -xzf $(LAZYGIT_TAR) lazygit
	@mv lazygit $(LOCAL_BIN)/
	@chmod +x $(LOCAL_BIN)/lazygit
	@rm $(LAZYGIT_TAR)
	@echo "✅ lazygit instalado com sucesso em $(LOCAL_BIN)"
