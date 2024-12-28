" bash
let g:is_bash = v:true

" java
let g:java_highlight_functions = 'style'
let g:java_highlight_all = v:true
let g:java_highlight_debug = v:true
let g:java_allow_cpp_keywords = v:true
let g:java_space_errors = v:true
let g:java_highlight_functions = v:true

" Tex
let g:tex_flavor = 'latex'

" markdown
" disable quotes keyword in markdown files
autocmd UserCmd BufEnter,BufRead,BufNewFile *.md setlocal iskeyword-='
" enable modeline in vim help files
autocmd UserCmd BufRead,BufWritePost *.txt,*.jax setlocal modeline

" auto re-detect filetype
autocmd UserCmd BufWritePost * nested
\ : if &l:filetype ==# '' || 'b:ftdetect'->exists()
\ |   unlet! b:ftdetect
\ |   silent filetype detect
\ | endif

" do this to skip loading default plugins 
let g:loaded_2html_plugin      = v:true
let g:loaded_getscriptPlugin   = v:true
let g:loaded_gtags             = v:true
let g:loaded_gtags_cscope      = v:true
let g:loaded_gzip              = v:true
let g:loaded_logiPat           = v:true
let g:loaded_man               = v:true
let g:loaded_matchit           = v:true
let g:loaded_matchparen        = v:true
let g:loaded_netrwFileHandlers = v:true
let g:loaded_netrwPlugin       = v:true
let g:loaded_netrwSettings     = v:true
let g:loaded_rrhelper          = v:true
let g:loaded_shada_plugin      = v:true
let g:loaded_spellfile_plugin  = v:true
let g:loaded_tarPlugin         = v:true
let g:loaded_tutor_mode_plugin = v:true
let g:loaded_vimballPlugin     = v:true
let g:loaded_zipPlugin         = v:true

