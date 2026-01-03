# Caminhos padrão do VSCodium (sem perfis bizarros)
VSC_USER_DIR := $(HOME)/.config/VSCodium/User
DOT_DIR := $(shell pwd)/vscodium

.PHONY: install backup

install:
	@echo "🔗 Linking settings to Default profile..."
	@mkdir -p $(VSC_USER_DIR)
	@rm -f $(VSC_USER_DIR)/settings.json $(VSC_USER_DIR)/keybindings.json
	@ln -sf $(DOT_DIR)/settings.json $(VSC_USER_DIR)/settings.json
	@ln -sf $(DOT_DIR)/keybindings.json $(VSC_USER_DIR)/keybindings.json
	@echo "🔓 Trusting workspace..."
	@mkdir -p $(VSC_USER_DIR)/globalStorage
	@echo '{"security.workspace.trust.allowedRequests": ["$(HOME)"]}' > $(VSC_USER_DIR)/globalStorage/storage.json
	@echo "📦 Installing extensions..."
	@cat $(DOT_DIR)/extensions.list | xargs -L 1 codium --install-extension
	@echo "✨ Done."

backup:
	@codium --list-extensions > $(DOT_DIR)/extensions.list
