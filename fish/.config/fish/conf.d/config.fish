# Fish Shell Configuration - Equivalent to zshrc/.config/zsh/config.zsh

# History settings (Fish equivalent)
set -gx SAVEHIST 1000000
set -gx HISTSIZE 1000000

# Fish already has good defaults for:
# - AUTO_CD: cd by typing directory name (enabled by default)
# - AUTO_LIST: automatically list choices (enabled by default)
# - AUTO_MENU: automatically use menu completion (enabled by default)

# Enable vi mode or emacs mode (emacs is default)
# fish_default_key_bindings

# ASDF configuration
set -gx ASDF_DIR "$HOME/.asdf"
if test -d "$ASDF_DIR"
    set -gx PATH "$ASDF_DIR/bin" $PATH
    set -gx PATH "$ASDF_DATA_DIR:$HOME/.asdf/shims" $PATH
    
    # Source ASDF completions for Fish
    if test -f "$ASDF_DIR/completions/asdf.fish"
        source "$ASDF_DIR/completions/asdf.fish"
    end
end

# SSH Agent setup
if test -z "$SSH_AGENT_PID"
    if test -f "$HOME/.ssh/personal_github"
        eval (ssh-agent -c)
        ssh-add ~/.ssh/personal_github
    end
end

# GPG (for signed commits)
set -gx GPG_TTY (tty)

# FZF key bindings for Fish
if type -q fzf
    # Enable FZF key bindings (Ctrl+R for history, Ctrl+T for files, Alt+C for cd)
    fzf --fish | source
end

# Tide prompt configuration (if installed)
# Run 'tide configure' to set up the prompt interactively