#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if running on macOS or Linux
OS="$(uname -s)"
case "${OS}" in
    Linux*)     MACHINE=Linux;;
    Darwin*)    MACHINE=Mac;;
    *)          MACHINE="UNKNOWN:${OS}"
esac

echo "🏠 Dotfiles Setup Script"
echo "Detected OS: $MACHINE"
echo

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to print status
print_status() {
    if command_exists "$1"; then
        echo -e "✅ $1 ${GREEN}installed${NC}"
        return 0
    else
        echo -e "❌ $1 ${RED}not installed${NC}"
        return 1
    fi
}

# Check for Homebrew first
check_brew() {
    if ! command_exists brew; then
        echo -e "${YELLOW}Installing Homebrew...${NC}"
        if [[ "$MACHINE" == "Mac" ]]; then
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        elif [[ "$MACHINE" == "Linux" ]]; then
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
            eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        fi
    else
        echo -e "✅ brew ${GREEN}installed${NC}"
    fi
}

# Install function
install_tool() {
    local tool=$1
    local brew_name=${2:-$tool}
    
    if [[ "$INSTALL" == "true" ]] && ! command_exists "$tool"; then
        echo -e "${YELLOW}Installing $tool...${NC}"
        brew install "$brew_name"
    fi
}

# Parse arguments
INSTALL=false
CHECK_ONLY=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --install)
            INSTALL=true
            shift
            ;;
        --check)
            CHECK_ONLY=true
            shift
            ;;
        *)
            echo "Usage: $0 [--install] [--check]"
            echo "  --install: Install missing tools via Homebrew"
            echo "  --check:   Only check status, don't install anything"
            exit 1
            ;;
    esac
done

# Check Homebrew
if [[ "$INSTALL" == "true" ]]; then
    check_brew
fi

echo "📦 Checking dependencies:"

# Check each tool
TOOLS="stow:stow nvim:neovim tmux:tmux fish:fish starship:starship fzf:fzf git:git tig:tig gitui:gitui zoxide:zoxide delta:git-delta"

for tool_pair in $TOOLS; do
    tool=${tool_pair%:*}
    brew_name=${tool_pair#*:}
    
    if print_status "$tool"; then
        continue
    elif [[ "$INSTALL" == "true" ]]; then
        install_tool "$tool" "$brew_name"
    fi
done

if [[ "$CHECK_ONLY" == "true" ]]; then
    exit 0
fi

echo
echo "🔗 Using GNU Stow to manage dotfiles:"

# Use stow to create symlinks
if command_exists stow; then
    echo "Stowing home directory files..."
    stow --adopt -t ~ home
    
    echo "Stowing config files..."
    stow --adopt -t ~/.config config
    
    echo -e "✅ ${GREEN}Dotfiles stowed successfully${NC}"
    echo -e "${YELLOW}Note: --adopt was used to handle conflicts. Check 'git status' for any changes.${NC}"
else
    echo -e "${RED}❌ GNU Stow not found. Install with: brew install stow${NC}"
    exit 1
fi

echo
echo "🎨 Setting up themes and plugins:"

# Install GitUI Catppuccin theme
if [[ ! -d ~/.config/gitui/catppuccin ]]; then
    echo "Installing GitUI Catppuccin theme..."
    git clone https://github.com/catppuccin/gitui.git ~/.config/gitui/catppuccin
    ln -sf ~/.config/gitui/catppuccin/themes/catppuccin-macchiato.ron ~/.config/gitui/theme.ron
    echo -e "✅ ${GREEN}GitUI theme installed${NC}"
else
    echo -e "✅ GitUI theme ${GREEN}already installed${NC}"
fi

# Install Fish plugins via Fisher (if fish is available and Fisher is installed)
if command_exists fish && [[ -f ~/.config/fish/functions/fisher.fish ]]; then
    echo "Installing Fish plugins..."
    fish -c "fisher update" 2>/dev/null || echo -e "${YELLOW}⚠️  Run 'fisher update' in fish to install plugins${NC}"
    echo -e "✅ ${GREEN}Fish plugins ready${NC}"
fi

echo
echo "🎉 Setup complete!"
echo
echo "Next steps:"
echo "1. Restart your shell or run: exec \$SHELL"
echo "2. For fish shell: chsh -s \$(which fish)"
echo "3. For nvim: run :checkhealth in neovim"
