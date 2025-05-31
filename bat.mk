install-bat-theme:
	@mkdir -p "$(shell bat --config-dir)/themes" && \
	cd "$(shell bat --config-dir)/themes" && \
	curl -O https://raw.githubusercontent.com/folke/tokyonight.nvim/main/extras/sublime/tokyonight_night.tmTheme && \
	cd ~/dotfiles && \
	bat cache --build && \
	echo "✅ Tema do bat instalado com sucesso!"

