" _ {{{
" no auto comments on new lines
setl formatoptions-=t formatoptions-=c
setl formatoptions-=r formatoptions-=o
setl formatoptions+=mMBl

" no autowrap 
if &l:textwidth != 70 && &filetype !=# 'help'
  setlocal textwidth=0
endif

" disable some ui in uneditable files
if !&l:modifiable
  setlocal nofoldenable
  setlocal foldcolumn=0
  setlocal colorcolumn=
endif
" }}}

" python {{{
"setlocal foldmethod=indent
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal textwidth=80
setlocal smarttab
setlocal expandtab
" }}}

" html {{{
setlocal includeexpr=v:fname->substitute('^\\/','','')
setlocal path+=./;/
" }}}

" vim {{{
setlocal shiftwidth=2 softtabstop=2
setlocal iskeyword+=:,#
setlocal indentkeys+=\\,endif,endfunction,endfor,endwhile,endtry
" }}}

" typescript {{{
setlocal shiftwidth=4
" }}}

" toml {{{
setlocal foldenable foldmethod=expr foldexpr=s:fold_expr(v:lnum)
function! s:fold_expr(lnum)
  const line = getline(a:lnum)
  return line ==# '' || line =~# '^\s\+'
endfunction
" }}}

" yaml {{{
setlocal iskeyword+=-
" dont want #s to change indent level in yaml files 
setlocal indentkeys-=0#
" }}}
