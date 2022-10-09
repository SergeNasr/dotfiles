# Installation
## 1. Soft Links
```
cd ~

ln -s ~/dotfiles/.zshrc ./.zshrc
ln -s ~/dotfiles/nvim/.config/nvim/vim-plug ./vim-plug
ln -s ~/dotfiles/nvim/.config/nvim/lua ./lua
ln -s ~/dotfiles/nvim/.config/nvim/init.vim ./init.vim
ln -s ~/dotfiles/nvim/.config/nvim ./.config/nvim
```

## 2. Vim Plug

Install vim plug in Vim's autoload directory.
I use `/Users/sergenasr/.local/share/nvim/site/autload/` 

```
sh -c 'curl -fLo $HOME/.local/share/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```

Then run `:PlugInstall` in vim. This will install all plugins in `/Users/sergenasr/.local/share/nvim/plugged`
Hence why in our `init.vim` we have the following line
`call plug#begin(stdpath('data') . '/plugged')`
