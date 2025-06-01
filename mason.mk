# Lista dos binários que já estão instalados via asdf/go install e você quer registrar no Mason
MASON_FAKE_LSPS := gopls golangci-lint-langserver delve mockery

# Caminho base onde o Mason procura binários
MASON_BIN_DIR := $(HOME)/.local/share/nvim/mason/bin
GOBIN := $(shell asdf where golang)/bin

.PHONY: mason-link-all mason-fake-all

# 🔗 Cria symlinks dos binários da lista acima para o Mason
mason-link-all:
	@echo "🔗 Criando symlinks para $(MASON_BIN_DIR)"
	@mkdir -p $(MASON_BIN_DIR)
	@for bin in $(MASON_FAKE_LSPS); do \
		if [ -f "$(GOBIN)/$$bin" ]; then \
			ln -sf "$(GOBIN)/$$bin" "$(MASON_BIN_DIR)/$$bin"; \
			echo "✅ Linkado: $$bin"; \
		else \
			echo "⚠️  Binário não encontrado: $(GOBIN)/$$bin"; \
		fi \
	done

# 📦 Cria package.json fake para o Mason reconhecer como instalado
mason-fake-all:
	@echo "📦 Registrando pacotes fake no Mason apenas se o binário existir..."
	@for bin in $(MASON_FAKE_LSPS); do \
		if [ -f "$(GOBIN)/$$bin" ]; then \
			mkdir -p $(HOME)/.local/share/nvim/mason/packages/$$bin; \
			echo '{ "name": "$$bin", "bin": { "$$bin": "$$bin" } }' > $(HOME)/.local/share/nvim/mason/packages/$$bin/package.json; \
			echo "✅ Fake registrado: $$bin"; \
		else \
			echo "❌ Pulando $$bin: binário não encontrado em $(GOBIN)"; \
		fi \
	done

# 🧪 Tarefa completa
mason-register: mason-link-all mason-fake-all
