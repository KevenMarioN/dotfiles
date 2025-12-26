# --- Configuration ---
DNF_CMD := sudo dnf
DOCKER_REPO_URL := https://download.docker.com/linux/fedora/docker-ce.repo
DOCKER_REPO_DEST := /etc/yum.repos.d/docker-ce.repo
# --- Targets ---
.PHONY: initial-all system-deps initial-tools initial-info clean-docker setup-docker install-docker configure-docker check-docker

initial-all: system-deps initial-tools install-docker

initial-info:
	@echo "ℹ️  This script installs native Fedora packages via DNF."
	@echo "    It covers Python build deps and tools like zoxide/jq/yq."

system-deps:
	@echo "📦 Installing System & Build Dependencies..."
	@# 'unzip' and 'git' are required for many ASDF plugins
	$(DNF_CMD) install -y unzip git make gcc patch

	@echo "🐍 Installing Python Build Dependencies (for ASDF)..."
	@# These are strictly required to compile Python via ASDF on Fedora
	$(DNF_CMD) install -y zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel \
		openssl-devel tk-devel libffi-devel xz-devel libuuid-devel \
		gdbm-devel libnsl2-devel

initial-tools:
	@echo "🛠️  Installing Native CLI Tools..."
	@# Tools that are faster/more stable via DNF than ASDF
	$(DNF_CMD) install -y zoxide jq yq

	@echo "✅ DNF installation complete."

clean-docker:
	@echo "🧹 Removing old/conflicting Docker versions..."
	@# Ignore errors if packages are not installed (|| true)
	$(DNF_CMD) remove -y docker \
		docker-client \
		docker-client-latest \
		docker-common \
		docker-latest \
		docker-latest-logrotate \
		docker-logrotate \
		docker-selinux \
		docker-engine-selinux \
		docker-engine \
		podman-docker || true
	@echo "✅ Cleanup done."

setup-repo:
	@echo "📦 Setting up official Docker repository..."
	@# FIX for Fedora 42 (DNF5): We download the .repo file directly
	@# instead of relying on 'dnf config-manager' syntax which changed.
	sudo curl -fsSL "$(DOCKER_REPO_URL)" -o "$(DOCKER_REPO_DEST)"
	@echo "✅ Repository added to $(DOCKER_REPO_DEST)."

install-docker: clean-docker setup-docker
	@echo "⬇️  Installing Docker Engine, CLI, and Compose..."
	$(DNF_CMD) install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
	@echo "✅ Packages installed."

configure-docker:
	@echo "⚙️  Starting Docker Service..."
	sudo systemctl start docker
	sudo systemctl enable docker

	@echo "👤 Adding user '$(USER)' to 'docker' group..."
	sudo groupadd docker || true
	sudo usermod -aG docker $(USER)
	@echo "✅ Configuration complete."

check-docker:
	@echo "🐳 Verifying installation..."
	@echo "   Docker Version: $$(docker --version)"
	@echo "   Compose Version: $$(docker compose version)"
	@echo ""
	@echo "⚠️  IMPORTANT: You must LOG OUT and LOG BACK IN for the group changes to take effect!"
	@echo "   (Or run 'newgrp docker' in this terminal to use it immediately)"
