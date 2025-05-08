#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting dotfiles installation...${NC}"

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo -e "${YELLOW}Installing Homebrew...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo -e "${GREEN}Homebrew already installed.${NC}"
fi

# Install essential tools
echo -e "${YELLOW}Installing essential tools...${NC}"
brew install neovim pyenv

# Backup existing zshrc
if [ -f ~/.zshrc ]; then
    echo -e "${YELLOW}Backing up existing .zshrc...${NC}"
    mv ~/.zshrc ~/.zshrc.backup
fi

# Create soft links
echo -e "${YELLOW}Creating soft links...${NC}"
cd ~

# Create necessary directories if they don't exist
mkdir -p ~/.config

# Create the symbolic links
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/nvim/.config/nvim/vim-plug ~/vim-plug
ln -sf ~/dotfiles/nvim/.config/nvim/lua ~/lua
ln -sf ~/dotfiles/nvim/.config/nvim/init.vim ~/init.vim
ln -sf ~/dotfiles/nvim/.config/nvim ~/.config/nvim

# Set Mac OS preferences
echo -e "${YELLOW}Setting Mac OS preferences...${NC}"

# Set key repeat rate
defaults write -g KeyRepeat -int 1
defaults write -g InitialKeyRepeat -int 10

# Set press and hold for VS Code/Cursor
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool true

# Configure Git
echo -e "${YELLOW}Configuring Git...${NC}"
git config --global pager.branch false

# Remind about manual steps
echo -e "${GREEN}Automated installation complete!${NC}"
echo -e "${YELLOW}Manual steps required:${NC}"
echo "1. Install iTerm2 from https://iterm2.com/"
echo "2. Configure iTerm2 with 'Natural Text Editing' key bindings"
echo "3. Install Rectangle from https://rectangleapp.com/"
echo "4. Install Fira Code font from NerdFonts (https://www.nerdfonts.com/)"
echo "5. Select the .ttf font and install it, then select it in iTerm2 profile settings"
echo "6. Open nvim and run :PlugInstall to install all plugins"
echo "7. Either open a new terminal or run 'source ~/.zshrc'" 