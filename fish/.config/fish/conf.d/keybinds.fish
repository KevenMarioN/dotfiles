# Key Bindings - Equivalent to zshrc/.config/zsh/keybinds.zsh

# Use emacs mode (default in Fish)
fish_default_key_bindings

# Ctrl+P - Search history backward (previous)
bind \cp history-search-backward

# Ctrl+N - Search history forward (next)
bind \cn history-search-forward

# Additional useful Fish keybindings:
# Ctrl+R - FZF history search (if FZF is installed)
# Ctrl+T - FZF file search (if FZF is installed)
# Alt+C - FZF directory change (if FZF is installed)

# Ctrl+L - Clear screen
bind \cl 'clear; commandline -f repaint'

# Ctrl+F - Accept autosuggestion
bind \cf forward-word

# Alt+L - List directory
bind \el 'ls; commandline -f repaint'