# Environment Variables - Equivalent to zshrc/.config/zsh/exports.zsh

# Editor settings
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx TABSIZE 2
set -gx SSH_TERM xterm-256color

# Starship config path
if type -q starship
    set -gx STARSHIP_CONFIG ~/.config/starship.toml
end

# Bat theme
if type -q bat
    set -gx BAT_THEME gruvbox-dark
end

# FZF colors (Gruvbox theme)
if type -q fzf
    set -gx FZF_DEFAULT_OPTS "$FZF_DEFAULT_OPTS \
        --color=fg:#ebdbb2,bg:#282828,hl:#fabd2f \
        --color=fg+:#ebdbb2,bg+:#3c3836,hl+:#fe8019 \
        --color=info:#83a598,prompt:#b8bb26,pointer:#fb4934 \
        --color=marker:#fb4934,spinner:#fabd2f,header:#83a598"
end

# Go private modules
set -gx GOPRIVATE github.com/KevenMarioN/*