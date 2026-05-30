# Aliases - Equivalent to zshrc/.config/zsh/aliases.zsh

# Basic aliases
alias zs='source ~/.config/fish/config.fish'
alias vim='nvim'
alias c='clear'

# Zoxide initialization (Fish native)
if type -q zoxide
    zoxide init fish | source
end

# Starship prompt
#if type -q starship
#    starship init fish | source
#end

# Bat as cat replacement
if type -q bat
    alias cat='bat'
end

# Eza aliases (modern ls replacement)
if type -q eza
    alias ls='eza --icons'
    alias ll='eza -l --icons --git --group-directories-first'
    alias la='eza -la --icons --git --group-directories-first'
    alias tree='eza --tree --icons'
end
