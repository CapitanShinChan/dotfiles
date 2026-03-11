" === BASICS ===
set nocompatible          " Use Vim defaults, not Vi
syntax on                 " Syntax highlighting
set encoding=utf-8        " UTF-8 everywhere

" === APPEARANCE ===
set number                " Show line numbers
set relativenumber        " Relative numbers (great for jumping)
set cursorline            " Highlight current line
set scrolloff=8           " Keep 8 lines visible above/below cursor
set colorcolumn=80        " Visual ruler at 80 chars
set showmatch             " Highlight matching brackets

" === INDENTATION ===
set expandtab             " Spaces instead of tabs
set tabstop=4             " Tab = 4 spaces
set shiftwidth=4          " Indent = 4 spaces
set autoindent
set smartindent

" === SEARCH ===
set hlsearch              " Highlight search results
set incsearch             " Search as you type
set ignorecase            " Case insensitive search...
set smartcase             " ...unless you type uppercase

" === USABILITY ===
set hidden                " Switch buffers without saving
set nowrap                " Don't wrap long lines
set backspace=indent,eol,start  " Backspace works everywhere
set clipboard=unnamedplus " Use system clipboard
set mouse=a               " Mouse support in terminal
set wildmenu              " Better command tab completion
set noswapfile            " No .swp files cluttering your projects
set nobackup
set undofile              " Persistent undo across sessions
set undodir=~/.local/share/nvim/undodir

" === KEYMAPS ===
let mapleader = " "       " Space as leader key

" Clear search highlight with Escape
nnoremap <Esc> :nohlsearch<CR>

" Move between splits with Ctrl+direction
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Save with leader+w
nnoremap <leader>w :w<CR>

" Quit with leader+q
nnoremap <leader>q :q<CR>

" Better indenting in visual mode (stays selected)
vnoremap < <gv
vnoremap > >gv
