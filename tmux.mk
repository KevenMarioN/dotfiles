tmux-plugins:
	@echo "🔧 Verificando se o tmux está instalado..."
	@which tmux >/dev/null 2>&1 || (echo "❌ Tmux não está instalado!"; exit 1)

	@echo "📦 Instalando TPM..."
	@test -d ~/.tmux/plugins/tpm || \
		git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

	@echo "📄 Verificando se existe .tmux.conf..."
	@test -e ~/.tmux.conf || \
		(cp tmux.conf.example ~/.tmux.conf && echo '✅ Criado .tmux.conf')

	@echo "🚀 Iniciando sessão temporária para instalar plugins..."
	@tmux new-session -d -s plugin_installer 'sleep 2; ~/.tmux/plugins/tpm/scripts/install_plugins.sh; sleep 1; exit'
	@sleep 5
	@tmux kill-session -t plugin_installer 2>/dev/null || true
	@echo "✅ Plugins do Tmux instalados."

reload-tmux:
	@if tmux info &>/dev/null; then \
		echo "♻️ Recarregando configuração do tmux..."; \
		tmux source-file ~/.tmux.conf && echo "✅ tmux.conf recarregado"; \
	else \
		echo "⚠️ Nenhuma sessão tmux ativa. Inicie o tmux antes de recarregar."; \
	fi

tmux-config: tmux-plugins reload-tmux
