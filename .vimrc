set nocompatible
set encoding=utf-8


"----Vundle-------------------------------------------------------------------"
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'ycm-core/YouCompleteMe'
Plugin 'dense-analysis/ale'
Plugin 'preservim/tagbar'
Plugin 'ludovicchabant/vim-gutentags'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'raimondi/delimitmate'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'scrooloose/nerdtree'
Plugin 'kaicataldo/material.vim'
Plugin 'mhinz/vim-startify'

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

" New leader
let mapleader = " "
let maplocalleader = "  "

nmap <leader>fw <Plug>(YCMFindSymbolInWorkspace)
nmap <leader>fd <Plug>(YCMFindSymbolInDocument)

"----Usability and Functionality----------------------------------------------"

" Capture mouse
set mouse=a

noremap <Leader>y "*y
noremap <Leader>p "*p

" Case-insensitive search expt when CAP
set ignorecase
set smartcase

" Backspace over indents, endofline, insrt
set backspace=indent,eol,start

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

" Ignore common
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows

" Close buffer and auto switch to previous
nnoremap <leader>d :bp\|bd #<CR>
" Open new window and switch to next buffer
nnoremap <leader>vs :vs\|bn<CR>

" NERDTree
map <C-n> :NERDTreeToggle<CR>

" Terminal escape
tnoremap <Esc><Esc> <C-\><C-n>

" Tagbar
let g:tagbar_autofocus=1
nmap <leader>tt :TagbarToggle<CR>
nnoremap <leader>to :exec "TagbarOpen j"<CR>

" CtrlP
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
if executable('ag')
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif
let g:ctrlp_extensions = ['tag', 'buffertag']
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn|build|__pycache__)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }

"----Style--------------------------------------------------------------------"
" Visual bell instead of audible bell
set visualbell

set cursorline
set cursorcolumn

set colorcolumn=80

" Numbering
set number relativenumber
autocmd InsertEnter * :set norelativenumber
autocmd InsertLeave * :set relativenumber

" Color scheme
set termguicolors
set background=dark
colorscheme material
let g:material_theme_style = 'darker'
let g:material_terminal_italics = 0
let g:airline_powerline_fonts=0
let g:airline_theme='material'
set term=xterm-256color

" Status Line
set laststatus=2
let g:airline#extensions#tabline#enabled=1
let g:airline_section_b = '%{strftime("%c")}'
let g:airline_section_c = '%F'
let g:ariline_section_d = '%{gutentags#statusline()}'

" Don't wrap text
set nowrap

" Persistent ruler
set ruler

" Auto NERDTree
"autocmd vimenter * NERDTree

" ALE
" let g:ale_linters = {
"             \ 'python': ['pylint'],
"             \}
let g:ale_fixers = {
            \ '*': ['remove_trailing_lines', 'trim_whitespace'],
            \ 'python': ['black', 'isort'],
            \}
let g:ale_fix_on_save = 1
" let g:ale_lint_delay = 350 " Wait longer before checking for syntax errors
" let g:ale_python_auto_pipenv = 1
let g:ale_virtualenv_dir_names = []

"----Syntax-------------------------------------------------------------------"
syntax enable

" Search setting
set nohlsearch
set incsearch
set ignorecase

" Use soft tabs
set expandtab
set smarttab
set shiftwidth=4
set softtabstop=4

" Copy indentation from previous line
set autoindent

" Regular Expressions
set magic
