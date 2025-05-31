install-git-delta:
	@mkdir -p ~/.local/bin && \
	curl -LO https://github.com/dandavison/delta/releases/download/0.17.0/git-delta_0.17.0_amd64.deb && \
	sudo dpkg -i git-delta_0.17.0_amd64.deb && \
	rm git-delta_0.17.0_amd64.deb

configure-git-delta:
	@which delta >/dev/null && \
	(git config --global core.pager delta && \
	 git config --global interactive.diffFilter "delta --color-only" && \
	 git config --global delta.navigate true && \
	 git config --global delta.side-by-side true && \
	 git config --global delta.dark true && \
	 git config --global merge.conflictstyle diff3 && \
	 git config --global diff.colorMoved default && \
	 echo "✅ delta configurado!") || \
	echo "❌ delta não encontrado, configuração ignorada."

