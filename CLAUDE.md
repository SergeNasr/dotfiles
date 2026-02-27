# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A macOS dotfiles repository managing configuration for zsh, neovim, tmux, iTerm2, and skhd. All configs are symlinked from `~/dotfiles/` into their expected locations via `install.sh`.

## Setup

```bash
chmod +x install.sh && ./install.sh
```

The install script symlinks configs, installs Homebrew packages (neovim, pyenv, tmux, skhd), sets macOS keyboard preferences, and configures iTerm2. Post-install: run `:PlugInstall` in nvim and `prefix + I` in tmux for plugins.

## Repository Structure

- `.zshrc` — Zsh config (oh-my-zsh + powerlevel10k theme, lazy-loaded pyenv, custom aliases/functions)
- `.tmux.conf` — Tmux config (vi keys, mouse, Alt+hjkl pane nav, tpm plugin manager)
- `nvim/.config/nvim/` — Neovim config (vim-plug, gruvbox theme, LSP via mason, telescope, treesitter)
  - `init.vim` — Base vim settings + plugin declarations (vim-plug)
  - `lua/serge/init.lua` — Entry point that requires all Lua modules
  - `lua/serge/` — Individual Lua configs: keymaps, lightline, telescope, mason
- `skhdrc` — skhd hotkey daemon config (hyper key app launchers)
- `iterm2/` — iTerm2 preferences and gruvbox color scheme
- `install.sh` — Automated setup script

## Symlink Mapping

The install script creates these symlinks (source → target):
- `.zshrc` → `~/.zshrc`
- `.tmux.conf` → `~/.tmux.conf`
- `nvim/.config/nvim/` → `~/.config/nvim`
- `skhdrc` → `~/.skhdrc`

## Key Conventions

- Neovim plugins are managed with **vim-plug** (declared in `init.vim`, installed via `:PlugInstall`)
- Neovim Lua config lives under `lua/serge/` and is loaded via `require('serge')` in `init.vim`
- LSP servers are managed through **mason.nvim** (configured in `lua/serge/mason.lua`)
- Tmux plugins use **tpm** (declared in `.tmux.conf`, installed via `prefix + I`)
- Shell performance optimizations are intentional: lazy-loaded pyenv, cached compinit, disabled oh-my-zsh auto-update
- Paths use `$HOME` rather than hardcoded usernames
