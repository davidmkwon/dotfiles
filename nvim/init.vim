" David Kwon's vimrc


" ************************************************
" PLUGINS
" ************************************************

call plug#begin('~/.local/share/nvim/plugged')

" language stuff
Plug 'fatih/vim-go', { 'tag': 'v1.22', 'do' : ':GoUpdateBinaries'}
Plug 'rust-lang/rust.vim'
Plug 'sheerun/vim-polyglot'

" color theme stuff
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'morhetz/gruvbox'

" code complete
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" file finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

call plug#end()


" ************************************************
" GENERAL
" ************************************************
:syntax on
:filetype plugin indent on
:set noerrorbells

" colorscheme
:colorscheme gruvbox
:set background=dark
:highlight LineNr ctermfg=grey
":highlight Comment ctermfg=green

" status bar
let g:airline_theme='cool'

" line limit
set colorcolumn=100
highlight ColorColumn ctermfg=grey

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
":set textwidth=80

" for file exploring
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_winsize = 25

" buffer stuff
:set hidden
:set nobackup
:set nowritebackup
:let g:airline#extensions#tabline#enabled = 1
:let g:airline#extensions#tabline#fnamemod = ':t'


" ************************************************
" LANGUAGE SPECIFIC CONFIGS
" ************************************************

" rust.vim stuff
let g:rustfmt_autosave = 1

" vim polygot for python
let g:python_highlight_space_errors=0

" make goimports be called when you save file
let g:go_fmt_command = 'goimports'
"let g:go_fmt_command = 'gopls'
"let g:go_imports_autosave = 1
"let g:go_metalinter_command = 'gopls'
"let g:go_gopls_staticcheck = 1


" ************************************************
" REMAPS
" ************************************************
" cntrl-c for exit
:imap <C-c> <Esc>

" set leader key to cntrl f
:nnoremap <C-f> <C-c>
:let mapleader = "\<C-f>"

" navigate windows with leader
":nnoremap <leader>h :wincmd h<CR>
":nnoremap <leader>j :wincmd j<CR>
":nnoremap <leader>k :wincmd k<CR>
":nnoremap <leader>l :wincmd l<CR>

" navigate tabs
:nnoremap <C-h> :tabprevious<CR>
:nnoremap <C-l> :tabnext<CR>
:nnoremap <C-j> :set hlsearch! hlsearch?<CR>

" nagivate buffers
:nnoremap <Leader>h :bp<CR>
:nnoremap <Leader>l :bn<CR>
:nnoremap <Leader>bs :ls<CR>

" show netrw on side
:nnoremap <leader>fv :wincmd v<bar> :Ex <bar> :vertical resize 30<CR>

" function that changes how much cntrl-u and cntrl-d scroll by
" currently set to 25% of screen
function! ScrollQuarter(move)
    let height=winheight(0)

    if a:move == 'up'
        let key="\<C-Y>"
    else
        let key="\<C-E>"
    endif

    "execute 'normal! ' . height/4 . key
    execute 'normal! ' . 12 . key
endfunction
" TODO: before setting these remaps, make the behavior for when you reach
" end of the buffer better
"nnoremap <C-u> :call ScrollQuarter('up')<CR>
"nnoremap <C-d> :call ScrollQuarter('down')<CR>
