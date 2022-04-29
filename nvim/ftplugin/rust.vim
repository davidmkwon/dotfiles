set textwidth=100
set colorcolumn=100

let g:rustfmt_autosave=0

" make `:fmt` run `:RustFmt`
command! Fmt :RustFmt |w |cw
