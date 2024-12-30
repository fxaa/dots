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

" go {{{
highlight default link goErr WarningMsg
match goErr /\<err\>/
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

" help {{{
setlocal iskeyword+=:
setlocal iskeyword+=#
setlocal iskeyword+=-
setlocal conceallevel=0

function! s:set_highlight(group) abort
  for group in ['helpBar', 'helpBacktick', 'helpStar', 'helpIgnore']
    execute 'highlight link' group a:group
  endfor
endfunction
call s:set_highlight('Special')

function! s:right_align(linenr) abort
  let m = a:linenr->getline()->matchlist(
        \ '^\(\%(\S\+ \?\)\+\)\?\s\+\([*|].\+[*|]\)')
  if m->empty()
    return
  endif
  call setline(a:linenr, m[1] .. ' '->repeat(
        \ &l:textwidth - len(m[1]) - len(m[2])) .. m[2])
endfunction
function! s:right_aligns(start, end) abort
  for linenr in range(a:start, a:end)
    call s:right_align(linenr)
  endfor
endfunction
command! -range -buffer RightAlign
      \ call s:right_aligns('<line1>'->expand(), '<line2>'->expand())

nnoremap <buffer> mm      <Cmd>RightAlign<CR>
xnoremap <silent><buffer> mm      :RightAlign<CR>
" }}}
