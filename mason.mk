# Lista dos binários que já estão instalados via asdf/go install e você quer registrar no Mason
MASON_FAKE_LSPS := gopls dlv mockery goimports gofumpt golines golangci-lint

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
			echo "{ \"name\": \"$$bin\", \"bin\": { \"$$bin\": \"$$bin\" } }" > $(HOME)/.local/share/nvim/mason/packages/$$bin/package.json; \
			echo "✅ Fake registrado: $$bin"; \
		else \
			echo "❌ Pulando $$bin: binário não encontrado em $(GOBIN)"; \
		fi \
	done

# 🔄 Remove todos os symlinks e pacotes fake
mason-reset-all:
	@echo "🧹 Limpando symlinks de $(MASON_BIN_DIR)..."
	@for bin in $(MASON_FAKE_LSPS); do \
		rm -f "$(MASON_BIN_DIR)/$$bin" && echo "❌ Removido: $$bin"; \
	done

	@echo "🧹 Limpando pacotes fake do Mason..."
	@for bin in $(MASON_FAKE_LSPS); do \
		rm -rf $(HOME)/.local/share/nvim/mason/packages/$$bin && echo "📦 Deletado pacote: $$bin"; \
	done

# 🧪 Tarefa completa
mason-register: mason-reset-all mason-link-all mason-fake-all
