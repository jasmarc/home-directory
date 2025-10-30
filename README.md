# 🏠 Dotfiles

Personal configuration files and setup scripts, maintained for ~15 years.

## Evolution

This repo has evolved through different eras of my shell preferences:
- **Early days**: Custom bash configurations
- **Middle years**: Custom zsh, then Oh My Zsh with zsh-quickstart-kit
- **Current**: Fish shell with Starship prompt and minimal modifications

I now prefer curated, out-of-the-box experiences over heavy customization. The focus is on tools that work well with minimal configuration while maintaining a consistent catppuccin/darcula aesthetic.

## Platform Support

Primarily designed for **macOS** but attempts to maintain cross-platform compatibility where possible.

## Quick Start

```bash
# Check what's installed
./setup.sh --check

# Install missing tools and setup symlinks
./setup.sh --install
```

## Dependencies

All managed via **Homebrew** (macOS) or **Linuxbrew** (Linux):
- **GNU Stow**: Dotfile symlink management
- **Fish**: Modern shell with syntax highlighting  
- **Starship**: Cross-shell prompt
- **Neovim**: LazyVim-based editor config
- **Tmux**: Terminal multiplexer with Dracula theme
- **FZF**: Fuzzy finder integration
- **Git**: Version control with global config
- **Tig**: Text-mode interface for Git
- **GitUI**: Blazing fast terminal Git UI
- **Zoxide**: Smarter cd command
- **Delta**: Syntax-highlighting pager for Git

## What's Included

### Shell Configuration
- **Fish**: Primary shell with cross-platform brew detection and defensive coding
- **Zsh**: Legacy modular configuration in `.zshrc.d/`
- **Starship**: Consistent prompt across shells
- **DRY Approach**: Shared `.zshrc.d/` modules work in both fish (via bass) and zsh

### Development Tools
- **Neovim**: LazyVim + Catppuccin + Java support
- **Tmux**: Dracula theme, mouse support
- **Ghostty**: Terminal with Catppuccin Mocha theme
- **Git**: Global configuration and ignore patterns
- **Tig**: Git TUI with custom colors
- **GitUI**: Fast terminal Git interface with Catppuccin theme
- **Zoxide**: Smart directory navigation
- **Delta**: Enhanced Git diffs with syntax highlighting

### Directory Structure

```
├── setup.sh              # GNU Stow-based setup script
├── home/                  # Files for $HOME (stow -t ~ home)
│   ├── .gitconfig
│   ├── .gitignore_global
│   ├── .tmux.conf
│   ├── .tigrc
│   └── .zshrc.d/         # Legacy modular zsh config
└── config/               # Files for ~/.config (stow -t ~/.config config)
    └── .config/
        ├── starship.toml
        ├── fish/
        ├── nvim/         # LazyVim configuration
        ├── ghostty/      # Terminal config + catppuccin theme
        └── gitui/        # Git TUI with catppuccin theme
```

## Setup Script

The setup script uses **GNU Stow** for symlink management:

- `--check`: Only check if tools are installed
- `--install`: Install missing tools via Homebrew

**What it does:**
1. ✅ Installs Homebrew/Linuxbrew if missing
2. 📦 Checks for required tools (installs if `--install` flag used)
3. 🔗 Uses `stow` to create symlinks from repo to home directory
4. 🎨 Installs GitUI Catppuccin theme from GitHub
5. 🐟 Updates Fish plugins via Fisher

## External Dependencies

Some configurations require external repositories that are installed automatically:

- **GitUI Theme**: [Catppuccin GitUI](https://github.com/catppuccin/gitui) - Cloned to `~/.config/gitui/catppuccin/`
- **Fish Plugins**: Managed by [Fisher](https://github.com/jorgebucaran/fisher) - Listed in `fish_plugins`

The setup script handles these automatically, but you can also install manually:

```bash
# GitUI Catppuccin theme
git clone https://github.com/catppuccin/gitui.git ~/.config/gitui/catppuccin
ln -sf ~/.config/gitui/catppuccin/themes/catppuccin-macchiato.ron ~/.config/gitui/theme.ron

# Fish plugins (run in fish shell)
fisher update
```

## Manual Setup

If you prefer manual setup:

```bash
# Install dependencies
brew install stow fish starship neovim tmux fzf git tig gitui zoxide git-delta

# Stow dotfiles
stow -t ~ home
stow -t ~/.config config
```

## Theme Consistency

Most tools configured with **Catppuccin Mocha** or **Darcula** themes:
- Ghostty: Catppuccin Mocha
- GitUI: Catppuccin Macchiato  
- Neovim: Catppuccin (via LazyVim)
- Tmux: Dracula theme
- Starship: Custom prompt colors

## Notes

- **Cross-platform**: Fish config detects macOS/Linux and uses appropriate Homebrew paths
- **Fish shell**: Run `chsh -s $(which fish)` to set as default
- **Neovim**: Run `:checkhealth` after first launch  
- **Private configs**: Proprietary/private settings kept in separate files (not tracked)
- **Legacy zsh**: Kept for compatibility but fish is preferred
- **Modular approach**: `.zshrc.d/` files work in both zsh and fish (via bass plugin)
