FZF_GIT_DIR := $(HOME)/fzf-git.sh
FZF_GIT_REPO := https://github.com/junegunn/fzf-git.sh.git

.PHONY: install-fzf-git update-fzf-git

install-fzf-git:
	@if [ -d "$(FZF_GIT_DIR)" ]; then \
		echo "⚠️  fzf-git.sh já está instalado em $(FZF_GIT_DIR)"; \
	else \
		echo "📦 Clonando fzf-git.sh para $(FZF_GIT_DIR)"; \
		git clone $(FZF_GIT_REPO) $(FZF_GIT_DIR); \
		echo "✅ Instalação concluída."; \
	fi

update-fzf-git:
	@if [ -d "$(FZF_GIT_DIR)" ]; then \
		echo "🔄 Atualizando fzf-git.sh..."; \
		cd $(FZF_GIT_DIR) && git pull; \
		echo "✅ Atualizado com sucesso."; \
	else \
		echo "❌ fzf-git.sh não encontrado. Rode 'make install-fzf-git' primeiro."; \
	fi
