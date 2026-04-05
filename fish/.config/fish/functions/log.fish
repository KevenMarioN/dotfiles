# Logging Functions - Equivalent to zshrc/.config/zsh/functions.zsh

# Reset color
set -l RESET '\033[0m'

# Normal colors
set -l RED '\033[0;31m'
set -l GREEN '\033[0;32m'
set -l YELLOW '\033[0;33m'
set -l CYAN '\033[0;36m'

# Log functions
function log -d "Print a cyan message"
    printf "$CYAN%s$RESET\n" $argv
end

function loginfo -d "Print a blue info message"
    printf "🔵 $CYAN%s$RESET\n" $argv
end

function logsuccess -d "Print a green success message"
    printf "🟢 $GREEN%s$RESET\n" $argv
end

function logwarning -d "Print a yellow warning message"
    printf "🟡 $YELLOW%s$RESET\n" $argv
end

function logerror -d "Print a red error message"
    printf "🔴 $RED%s$RESET\n" $argv
end

# dtouch - Create directory path and touch file
function dtouch -d "Create directory path and touch file"
    mkdir -p (dirname $argv[1])
    touch $argv[1]
end