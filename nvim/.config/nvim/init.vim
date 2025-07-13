" enables syntax highlighting
syntax on

set title

" number of spaces in a <Tab>
set tabstop=4
set softtabstop=4
set expandtab

" enable autoindents
set smartindent

" number of spaces used for autoindents
set shiftwidth=4

" adds line numbers
set number
set relativenumber

" columns used for the line number
set numberwidth=4

" highlights the matched text pattern when searching
set incsearch
set nohlsearch

" open splits intuitively
set splitbelow
set splitright

" navigate buffers without losing unsaved work
set hidden

" start scrolling when 8 lines from top or bottom
set scrolloff=8

" Save undo history
set undofile

" Enable mouse support
set mouse=a

" case insensitive search unless capital letters are used
set ignorecase
set smartcase

" vim-plug
call plug#begin(stdpath('data') . '/plugged')
	Plug 'neovim/nvim-lspconfig'
	Plug 'williamboman/mason.nvim'
	Plug 'williamboman/mason-lspconfig.nvim'
    Plug 'gruvbox-community/gruvbox'
    " Telescope requires plenary to function
    Plug 'nvim-lua/plenary.nvim'
    " The main Telescope plugin
    Plug 'nvim-telescope/telescope.nvim'
    " An optional plugin recommended by Telescope docs
    Plug 'nvim-telescope/telescope-fzf-native.nvim', {'do': 'make' }
    " A plugin for displaying a status line at the bottom
    Plug 'itchyny/lightline.vim'    
    " A git plugin
    Plug 'tpope/vim-fugitive'
    " Autocompletion + snippets plugin
    Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'L3MON4D3/LuaSnip'
    Plug 'saadparwaiz1/cmp_luasnip'
    Plug 'onsails/lspkind-nvim'
    " Treesitter: better highlighting
    Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
    " Vim Rhubarb: enables GBrowse in fugitive
    Plug 'tpope/vim-rhubarb'
call plug#end()

" declare your color scheme
colorscheme gruvbox

" Hide the the Vim Mode text under the lightline box
set noshowmode

lua require('serge')
