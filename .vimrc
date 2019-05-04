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
Plugin 'Valloric/YouCompleteMe'
Plugin 'raimondi/delimitmate'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'scrooloose/nerdtree'
Plugin 'jalvesaq/Nvim-R'
Plugin 'xuhdev/vim-latex-live-preview'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'benmills/vimux'
Plugin 'junegunn/goyo.vim'
Plugin 'NLKNguyen/papercolor-theme'

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

nnoremap <leader> " "

"----Usability and Functionality----------------------------------------------"
" Case-insensitive search expt when CAP
set ignorecase
set smartcase

" Use mouse
set mouse=a

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
" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Vimtex
let g:tex_flavor='pdflatex'
" let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmg'
let g:livepreview_previewer='open -a preview'

" Vimux
" Prompt for a command to run
map <Leader>vp :VimuxPromptCommand<CR>
" Run last command executed by VimuxRunCommand
map <Leader>vl :VimuxRunLastCommand<CR>
" Inspect runner pane
map <Leader>vi :VimuxInspectRunner<CR>
" Zoom the tmux runner pane
map <Leader>vz :VimuxZoomRunner<CR>
" Vertical split
let g:VimuxOrientation="h"

" Terminal escape
tnoremap <Esc> <C-\><C-n>

"----Style--------------------------------------------------------------------"
" Visual bell instead of audible bell
set visualbell

" Color scheme
set termguicolors
set background=dark
let g:PaperColor_Theme_Options = {
 \    'theme': {
 \        'default': {
 \            'transparent_background': 1
 \        }
 \    }
 \ }
colorscheme PaperColor
let g:airline_powerline_fonts=0
let g:airline_theme='papercolor'
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

" Snakemake
au BufNewFile,BufRead Snakefile set syntax=snakemake
au BufNewFile,BufRead *.smk set syntax=snakemake
