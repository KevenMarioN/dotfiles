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

# SSH Agent setup - Socket persistente para reutilização entre sessões
set -gx SSH_AGENT_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"

# Verifica se já existe um agente rodando com o socket
if not test -S "$SSH_AGENT_SOCK"
    # Inicia novo agente com socket fixo
    ssh-agent -a "$SSH_AGENT_SOCK" >/dev/null 2>&1
end

set -gx SSH_AUTH_SOCK "$SSH_AGENT_SOCK"

# Adiciona a chave apenas se o agente não tem identidades (apenas sessão interativa)
if status is-interactive; and test -f "$HOME/.ssh/personal"
    # Só adiciona se o agente estiver vazio (sem identidades)
    ssh-add -l >/dev/null 2>&1; or ssh-add "$HOME/.ssh/personal"
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