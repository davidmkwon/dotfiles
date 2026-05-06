" David Kwon's vimrc

" sick rust config in this video (init.vim is in comments)
" https://www.youtube.com/watch?v=16sU1q8OeeI

" ************************************************
" PLUGINS
" ************************************************
call plug#begin('~/.local/share/nvim/plugged')

" color theme stuff
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'morhetz/gruvbox'

" language stuff
" Plug 'fatih/vim-go', { 'tag': 'v1.22', 'do' : ':GoUpdateBinaries'}
Plug 'rust-lang/rust.vim'

" language server stuff
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'hrsh7th/cmp-nvim-lsp', {'branch': 'main'}
Plug 'hrsh7th/cmp-buffer', {'branch': 'main'}
Plug 'hrsh7th/cmp-path', {'branch': 'main'}
Plug 'hrsh7th/nvim-cmp', {'branch': 'main'}
" Only because nvim-cmp _requires_ snippets
Plug 'hrsh7th/cmp-vsnip', {'branch': 'main'}
Plug 'hrsh7th/vim-vsnip'
Plug 'folke/trouble.nvim'
Plug 'seblj/nvim-echo-diagnostics'

" file finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" NERDTree
Plug 'preservim/nerdtree'

" Treesitter for syntax highlighting
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

call plug#end()

" ************************************************
" GENERAL
" ************************************************
:syntax on
:filetype on
:filetype plugin on
:filetype plugin indent on
:set noerrorbells

" colorscheme
:set bg=dark
:let g:gruvbox_contrast_dark ='hard'
set termguicolors
:colorscheme gruvbox

":set bg=light
":let g:gruvbox_contrast_light='soft'
":set termguicolors
":set  t_Co=256
":colorscheme gruvbox

:highlight LineNr ctermfg=grey

" cursorline
:set cursorline
:hi CursorLine cterm=NONE ctermbg=237


" status bar
let g:airline_theme='cool'
let g:airline_symbols = {}
let g:airline_symbols.colnr = ' '

" line limit
" set textwidth=90
" set colorcolumn=90
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
:set cursorline

" add relative movements to the jump history so you can Ctrl-O/I them
"noremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'
"noremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'

" moving text in visual mode
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" buffer stuff
:set hidden
:set nobackup
:set nowritebackup
":let g:airline#extensions#tabline#enabled = 1
":let g:airline#extensions#tabline#fnamemod = ':t'
":let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
:se nosol

" fzf window stuff
let g:fzf_preview_window = ['right:50%', 'ctrl-/']
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.4, 'yoffset': 1.0 } }

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

" ************************************************
" REMAPS
" ************************************************
" cntrl-c for exit
:imap <C-c> <Esc>

" set leader key to cntrl f
"BRUH THIS ONE LINE BELOW LITERALLY CAUSED ME 2 HOURS OF PAIN
":nnoremap <C-f> <C-c>
:let mapleader = "\<C-f>"

" navigate windows with leader
:nnoremap <C-w>o <C-w><C-w>

" navigate tabs
:nnoremap <C-j> :set hlsearch! hlsearch?<CR>

" nagivate buffers
:nnoremap <C-h> :bp<CR>
:nnoremap <C-l> :bn<CR>

" closes buffer and keeps window open
:nnoremap <leader>q :bp\|bd #<CR>

" NERDTree
"
" show NERDTree remap
:nnoremap <Leader>f :NERDTreeToggle<CR>
" enable line numbers
let NERDTreeShowLineNumbers=1
" make sure relative line numbers are used
autocmd FileType nerdtree setlocal relativenumber

" make fzf use rg, specifically with the configuration to ignore .gitinogre
let $FZF_DEFAULT_COMMAND = "rg --files --hidden -g '!.git/'"

" file finder
:nnoremap <leader>p :Files<CR>

" FZF command show buffers
:nnoremap <leader>b :Buffers<CR>

"command! -nargs=+ -complete=file -bar AgCommand grep! <args>|cw
"command! -nargs=+ -complete=file -bar Grep grep! <args>|cw
"command! -nargs=+ -complete=file -bar Rgg :rg <args>
:nnoremap <leader>; :Rg<space>

" remap for omni
:inoremap <leader><C-h> <C-X><C-O>

" remap ctrl f+e since you always accidentally do this when asking for
" diagnostic messages
:nnoremap <C-f><C-e> <Nop>

" lsp-config stuff

lua << EOF
local cmp = require'cmp'

cmp.setup({
  snippet = {
    -- REQUIRED by nvim-cmp. get rid of it once we can
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    -- Tab immediately completes. C-n/C-p to select.
    ['<Tab>'] = cmp.mapping.confirm({ select = true }),
    ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item(), {'i','c'}),
    ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item(), {'i','c'}),
  },
  sources = cmp.config.sources({
    -- TODO: currently snippets from lsp end up getting prioritized -- stop that!
    { name = 'nvim_lsp' },
  }, {
    { name = 'path' },
  }),
  experimental = {
    ghost_text = true,
  },
})

-- set up lsp keymaps on attach
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    local opts = { buffer = bufnr, noremap = true, silent = true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<leader>d', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>r', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>e', function() vim.diagnostic.open_float(nil, { scope = "line" }) end, opts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
    vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format({ async = true }) end, opts)
  end,
})

-- set up capabilities for completion
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- rust-analyzer configuration
vim.lsp.config('rust_analyzer', {
  cmd = { 'rust-analyzer' },
  filetypes = { 'rust' },
  root_markers = { 'Cargo.toml' },
  settings = {
    ["rust-analyzer"] = {
      diagnostics = {
        enable = true,
      },
      cargo = {
        allFeatures = true,
        allTargets = true,
        tests = true,
      },
      completion = {
        postfix = {
          enable = false,
        },
      },
    },
  },
  capabilities = capabilities,
})

vim.lsp.enable('rust_analyzer')

-- gopls configuration
vim.lsp.config('gopls', {
  cmd = { "gopls", "serve" },
  filetypes = { "go", "gomod" },
  root_markers = { 'go.mod', 'go.work' },
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
    },
  },
  capabilities = capabilities,
})

vim.lsp.enable('gopls')

-- make the diagnostic messages not inlined
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = false,
        underline = true
    }
)

-- have diagonistics show up on hover and
ed = require("echo-diagnostics")
ed.setup{
    show_diagnostic_number = true
}

EOF

" stuff related to diagnostics in lspconfig
autocmd CompleteDone * pclose
"autocmd CursorHold * lua vim.lsp.diagnostic.show_position_diagnostics()
"nnoremap <leader>e :lua vim.lsp.diagnostic.show_entire_diagnostic()<CR>
"autocmd CursorHold * lua require('echo-diagnostics').echo_line_diagnostic()
"autocmd CursorHold * lua vim.diagnostic.open_float(nil, { scope = "line" })
nnoremap <leader>e :lua vim.diagnostic.open_float(nil, { scope = "line" })<CR>
"nnoremap <leader>e :lua require('echo-diagnostics').echo_entire_diagnostic()<CR>
set updatetime=300
set signcolumn=yes
