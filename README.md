# Installation

## 0. Prerequisites

1. Install [iTerm2](https://iterm2.com/)
2. Configure iTerm2:
   - Go to Profiles > Keys > Key Bindings > Presets
   - Select "Natural Text Editing"
3. Install [Homebrew](https://brew.sh/):
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```
4. Install essential tools:
   ```bash
   brew install neovim pyenv
   ```
5. Install [Rectangle](https://rectangleapp.com/) for window management
6. Backup existing zshrc (if it exists):
   ```bash
   mv ~/.zshrc ~/.zshrc.backup
   ```

## 1. Soft Links
```
cd ~

ln -s ~/dotfiles/.zshrc ./.zshrc
ln -s ~/dotfiles/nvim/.config/nvim/vim-plug ./vim-plug
ln -s ~/dotfiles/nvim/.config/nvim/lua ./lua
ln -s ~/dotfiles/nvim/.config/nvim/init.vim ./init.vim
ln -s ~/dotfiles/nvim/.config/nvim ./.config/nvim
```

After creating the soft links, either:
- Open a new terminal tab/window, or
- Run `source ~/.zshrc` to apply the p10k configuration

## 2. Vim Plug

After the soft links are created, open nvim and run `:PlugInstall` to install all plugins. This will install the plugins in `/Users/sergenasr/.local/share/nvim/plugged`, which is why in our `init.vim` we have the following line:
`call plug#begin(stdpath('data') . '/plugged')`

## 4. Iterm2

1. Install Fira Code font from [NerdFonts](https://www.nerdfonts.com/)
2. Select the `.ttf` font you like. Double click on it and install it
3. After installation, select in under your Iterm profile settings
