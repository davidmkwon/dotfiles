" David Kwon's vimrc


" ************************************************
" PLUGINS
" ************************************************
call plug#begin('~/.local/share/nvim/plugged')

" language stuff
Plug 'fatih/vim-go', { 'tag': 'v1.22', 'do' : ':GoUpdateBinaries'}
Plug 'rust-lang/rust.vim'
Plug 'vim-syntastic/syntastic', { 'for': 'ocaml' }

" color theme stuff
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'morhetz/gruvbox'

" code complete
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" file finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" NERDTree
Plug 'preservim/nerdtree'

call plug#end()

" ************************************************
" GENERAL
" ************************************************
:syntax on
:filetype on
:filetype plugin indent on
:set noerrorbells

" colorscheme
:colorscheme gruvbox
:set background=dark
:highlight LineNr ctermfg=grey

" cursorline
:set cursorline
:hi CursorLine cterm=NONE ctermbg=237

" status bar
let g:airline_theme='cool'

" line limit
set textwidth=90
set colorcolumn=90
highlight ColorColumn ctermfg=grey

" formatting settings
:set guicursor=
:set number
:set relativenumber
:set tabstop=2
:set softtabstop=2
:set shiftwidth=2
:set expandtab
:set smartindent
:set noswapfile
:set backspace=indent,eol,start
:set belloff=all
:set incsearch
:set encoding=utf-8
:set mouse=a
:set cursorline

" buffer stuff
:set hidden
:set nobackup
:set nowritebackup
":let g:airline#extensions#tabline#enabled = 1
":let g:airline#extensions#tabline#fnamemod = ':t'
":let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
:se nosol

" fzf window stuff
"let g:fzf_preview_window = ['right:50%', 'ctrl-/']
:let g:fzf_layout = { 'down': '~30%'}

" Start NERDTree and put the cursor back in the other window.
" autocmd VimEnter * NERDTree | wincmd p

" Save current view settings on a per-window, per-buffer basis.
function! AutoSaveWinView()
    if !exists("w:SavedBufView")
        let w:SavedBufView = {}
    endif
    let w:SavedBufView[bufnr("%")] = winsaveview()
endfunction

" Restore current view settings.
function! AutoRestoreWinView()
    let buf = bufnr("%")
    if exists("w:SavedBufView") && has_key(w:SavedBufView, buf)
        let v = winsaveview()
        let atStartOfFile = v.lnum == 1 && v.col == 0
        if atStartOfFile && !&diff
            call winrestview(w:SavedBufView[buf])
        endif
        unlet w:SavedBufView[buf]
    endif
endfunction

" When switching buffers, preserve window view.
if v:version >= 700
    autocmd BufLeave * call AutoSaveWinView()
    autocmd BufEnter * call AutoRestoreWinView()
endif

" ************************************************
" LANGUAGE SPECIFIC CONFIGS
" ************************************************

" ocaml stuff
let g:opamshare = substitute(system('opam config var share'), '\n$', '', '''')
set rtp+=~/.config/ocp-indent-vim
execute "set rtp+=" . g:opamshare . "/merlin/vim"
execute "helptags " . substitute(system('opam config var share'),'\n$','','''') .  "/merlin/vim/doc"

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
:nnoremap <C-w>o <C-w><C-w>

" navigate tabs
":nnoremap <Leader>h :tabprevious<CR>
":nnoremap <Leader>l :tabnext<CR>
":nnoremap <Leader>bs :ls<CR>
:nnoremap <C-j> :set hlsearch! hlsearch?<CR>

" nagivate buffers
":nnoremap <Leader>h :bp<CR>
":nnoremap <Leader>l :bn<CR>
":nnoremap <Leader>bs :ls<CR>
:nnoremap <C-h> :bp<CR>
:nnoremap <C-l> :bn<CR>
":nnoremap <leader>bd :bp\|bd #<CR>

" closes buffer (and the current window it's in if it's not the main window)
":nnoremap <Leader>qw :bd<CR>
" closes buffer and keeps window open
:nnoremap <leader>q :bp\|bd #<CR>

" show netrw on side
":nnoremap <leader>fv :wincmd v<bar> :Ex <bar> :vertical resize 30<CR>

" show NERDTree remap
:nnoremap <Leader>f :NERDTree<CR>

" file finder
" FZF command `:Files` remap
"command! -nargs=+ -complete=file -bar FindFile :Files <args>|cw
":nnoremap <leader>p :Files<space>
:nnoremap <leader>p :Files<CR>

" FZF command show buffers
:nnoremap <leader>b :Buffers<CR>

"command! -nargs=+ -complete=file -bar AgCommand grep! <args>|cw
"command! -nargs=+ -complete=file -bar Grep grep! <args>|cw
command! -nargs=+ -complete=file -bar Agh :Ag <args>|cw
:nnoremap <leader>; :Agh<space>

" remap for omni
:inoremap <leader><C-h> <C-X><C-O>

" close syntastic error window
":nnoremap <Leader>sr :SyntasticReset<CR>

" coc nvim show documentation in new window
"nnoremap <silent> K :call <SID>show_documentation()<CR>
" Use K to show documentation in preview window.
"nnoremap <silent> K :call <SID>show_documentation()<CR>

" coc nvim remaps
:nnoremap <leader>e :<C-u>CocList diagnostics<cr>
:nnoremap <leader>d :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction
