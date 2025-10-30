# Cross-platform Homebrew detection
if test -f /opt/homebrew/bin/brew
    /opt/homebrew/bin/brew shellenv | source          # Apple Silicon Mac
else if test -f /usr/local/bin/brew  
    /usr/local/bin/brew shellenv | source             # Intel Mac
else if test -f /home/linuxbrew/.linuxbrew/bin/brew
    /home/linuxbrew/.linuxbrew/bin/brew shellenv | source  # Linux
end

# Brazil Python interpreter configuration
set -gx BRAZILPYTHON_INTERPRETERS "CPython310,CPython311"

# or, more manually:
#set -gx PATH /opt/homebrew/bin /opt/homebrew/sbin $PATH
#set -gx MANPATH /opt/homebrew/share/man $MANPATH
#set -gx INFOPATH /opt/homebrew/share/info $INFOPATH
#
if status is-interactive
    # Initialize starship if available
    if command -v starship >/dev/null
        starship init fish | source
    end
    
    set -U fish_autosuggestion_enabled 1

    # Source legacy zsh/bash files via bass
    for file in (find ~/.zshrc.d/ -type f)
        if not string match -q '*.zsh' "$file"
            bass source "$file"
        end
    end

    # Source fish-native files
    for file in (find ~/.fishrc.d/ -type f)
        source $file
    end

    # Initialize zoxide if available
    if command -v zoxide >/dev/null
        zoxide init fish | source
    end
end
