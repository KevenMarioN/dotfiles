# Keven Mario - Fish Shell Configuration
# Main entry point - loads all configuration files

# Source all configuration files in conf.d
for file in ~/.config/fish/conf.d/*.fish
    source $file
end

# Source environment file if it exists
test -f ~/.env && source ~/.env
