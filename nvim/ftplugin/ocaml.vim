set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set textwidth=80
set colorcolumn=80

set textwidth=80
set colorcolumn=80

" syntastic settings
let g:syntastic_mode_map = {
            \ 'mode': 'passive',
            \ 'active_filetypes': ['ocaml'],
            \ 'passive_filetypes': [] }
let g:syntastic_check_on_open = 0
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_ocaml_checkers = ['merlin']

" (ocaml) merlin bindings
:nnoremap <leader>t :MerlinTypeOf<CR>
