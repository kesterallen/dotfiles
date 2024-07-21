
set nocompatible
set encoding=utf-8

set ai
set et
set ts=4
set sw=4
autocmd FileType javascript setlocal ts=4 sts=4 sw=4
autocmd FileType html setlocal ts=2 sts=2 sw=2
autocmd FileType css setlocal ts=2 sts=2 sw=2
autocmd FileType md setlocal ts=2 sts=2 sw=2

set noru
set hlsearch
"set incsearch
set ignorecase " ignore case
set smartcase " unless you specify a uppercase letter 

set backspace=

"set relativenumber " meh
set guifont=Monospace\ 10
set noerrorbells

set tags=./tags;,tags;

syntax on
colors koehler

let loaded_matchparen = 1 " This turns off matching-paren highlighting

map K Oimport ipdb; ipdb.set_trace()<esc>


" For vim-plug https://github.com/junegunn/vim-plug (currently uninstalled)
"call plug#begin()
"
"" List your plugins here
"Plug 'tpope/vim-sensible'
"
"" Use release branch (recommended)
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
"
"" LSP for nvim
"Plug 'neovim/nvim-lspconfig'
"Plug 'williamboman/mason.nvim'
"Plug 'williamboman/mason-lspconfig.nvim'
"
"call plug#end()
