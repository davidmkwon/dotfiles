:syntax on
:filetype plugin indent on

" vim polygot for python
let g:python_highlight_space_errors=0

" make goimports be called when you save file
let g:go_fmt_command = 'goimports'
"let g:go_fmt_command = 'gopls'
"let g:go_imports_autosave = 1
"let g:go_metalinter_command = 'gopls'
"let g:go_gopls_staticcheck = 1

call plug#begin('~/.local/share/nvim/plugged')

Plug 'fatih/vim-go', { 'tag': 'v1.22', 'do' : ':GoUpdateBinaries'}
Plug 'sheerun/vim-polyglot'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'morhetz/gruvbox'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

" for file exploring
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 3
let g:netrw_winsize = 25

" colorscheme
:colorscheme gruvbox
:set background=dark
:highlight LineNr ctermfg=grey
":highlight Comment ctermfg=green

" status bar
let g:airline_theme='cool'

" formatting settings
:set guicursor=
:set number
:set relativenumber
:set tabstop=4
:set softtabstop=4
:set shiftwidth=4
:set expandtab
:set smartindent
:set noswapfile
:set backspace=indent,eol,start
:set belloff=all
:set incsearch
:set encoding=utf-8
:set mouse=a

" idk at this point
:set hidden
:set nobackup
:set nowritebackup

" key remaps
nnoremap <C-h> :tabprevious<CR>
:nnoremap <C-l> :tabnext<CR>
:nnoremap <C-j> :set hlsearch! hlsearch?<CR>
:imap <C-c> <Esc>
