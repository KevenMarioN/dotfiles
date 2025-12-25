# Define the history file path using the HOME environment variable
HIST_FILE := $(HOME)/.zsh_history

# .PHONY indicates that 'setup-history' is a command, not a file to be built
.PHONY: setup-history

setup-history:
	@echo "🔍 Checking history file..."
	@if [ ! -f "$(HIST_FILE)" ]; then \
		echo "🆕 File not found. Creating $(HIST_FILE)..."; \
		touch "$(HIST_FILE)"; \
	else \
		echo "✅ File already exists."; \
	fi
	@echo "🔒 Setting permissions to 600 (read/write for owner only)..."
	@chmod 600 "$(HIST_FILE)"
	@echo "🎉 All done! History file is configured correctly."
