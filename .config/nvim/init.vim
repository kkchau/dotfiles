set nocompatible
set encoding=utf-8


"----Vundle-------------------------------------------------------------------"
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
" Plugin 'Valloric/YouCompleteMe'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'scrooloose/nerdtree'
Plugin 'jalvesaq/Nvim-R'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line


"----Commands-----------------------------------------------------------------"
" Better command-line completion
set wildmenu

" Show partial commands in the last line
set showcmd


"----Usability and Functionality----------------------------------------------"
" Case-insensitive search expt when CAP
set ignorecase
set smartcase

" Backspace over indents, endofline, insrt
set backspace=indent,eol,start

" Cursor pos 
set ruler

" Confirmation of unsaved changes
set confirm

" split screen and navigation
set splitbelow
set splitright

" split navigation
map <C-J> <C-W>j
map <C-K> <C-W>k
map <C-H> <C-W>h
map <C-L> <C-W>l

" NERDTree
map <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Code folding
set foldmethod=indent
set foldlevel=99
nnoremap <space> za


"----Style--------------------------------------------------------------------"
" Visual bell instead of audible bell
set visualbell

" Color scheme
set background=dark
colorscheme slate
let g:airline_powerline_fonts=1
let g:airline_theme='ravenpower'
" set t_Co=16
" set term=screen-256color

" Status Line
set laststatus=2
let g:airline#extensions#tabline#enabled=1
let g:airline_section_b = '%{strftime("%c")}'
let g:airline_section_c = '%F'

" Don't wrap text
set nowrap

" Persistent ruler
set ruler

" Auto NERDTree
"autocmd vimenter * NERDTree

"----Syntax-------------------------------------------------------------------"
syntax enable

" Search setting
set nohlsearch
set incsearch
set ignorecase

" Numbering
set nu

" Use soft tabs
set expandtab
set smarttab
set shiftwidth=4
set softtabstop=4

" Copy indentation from previous line
set autoindent

" Regular Expressions
set magic
