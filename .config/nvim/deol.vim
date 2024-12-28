" hook_add {{{
nnoremap [Space]s
      \ <Cmd>call deol#start(#{
      \   command: [has('win32') ? 'cmd': 'zsh'],
      \   start_insert: v:false,
      \ })<CR>
nnoremap sD  <Cmd>call deol#kill_editor()<CR>
nnoremap <C-t> <Cmd>Ddu -name=deol -sync
      \ -ui-param-ff-split=`has('nvim') ? 'floating' : 'horizontal'`
      \ -ui-param-ff-winRow=1
      \ -ui-param-ff-autoResize
      \ -ui-param-ff-cursorPos=`tabpagenr()`
      \ deol<CR>
" }}}

" hook_source {{{
call deol#set_option(#{
      \    internal_history_path: '~/.cache/deol-history',
      \    nvim_server: '~/.cache/nvim/server.pipe',
      \    prompt_pattern: has('win32') ? '\f\+>' : '\w*% \?',
      \ })
if !has('win32')
  call deol#set_option('external_history_path', '~/.zsh-history')
  call deol#set_option('command', ['zsh'])
endif

tnoremap <C-t> <Tab>
tnoremap <expr> <Tab> pum#visible() ?
      \ '<Cmd>call pum#map#select_relative(+1)<CR>' :
      \ '<Tab>'
tnoremap <expr> <S-Tab> pum#visible() ?
      \ '<Cmd>call pum#map#select_relative(-1)<CR>' :
      \ '<S-Tab>'
tnoremap <Down>   <Cmd>call pum#map#insert_relative(+1)<CR>
tnoremap <Up>     <Cmd>call pum#map#insert_relative(-1)<CR>
tnoremap <C-y>    <Cmd>call pum#map#confirm()<CR>
tnoremap <C-o>    <Cmd>call pum#map#confirm()<CR>
" }}}

" deol {{{
nnoremap <buffer> <C-n>  <Plug>(deol_next_prompt)
nnoremap <buffer> <C-p>  <Plug>(deol_previous_prompt)
nnoremap <buffer> <CR>   <Plug>(deol_execute_line)
nnoremap <buffer> A      <Plug>(deol_start_append_last)
nnoremap <buffer> I      <Plug>(deol_start_insert_first)
nnoremap <buffer> a      <Plug>(deol_start_append)
nnoremap <buffer> e      <Plug>(deol_edit)
nnoremap <buffer> i      <Plug>(deol_start_insert)
nnoremap <buffer> q      <Plug>(deol_quit)

nnoremap <buffer> [Space]gc
      \ <Cmd>call deol#send('git commit')<CR>
nnoremap <buffer> [Space]gs
      \ <Cmd>call deol#send('git status')<CR>
nnoremap <buffer> [Space]gA
      \ <Cmd>call deol#send('git commit --amend')<CR>

tnoremap <buffer><expr> <CR>
      \ (pum#visible() ? '<Cmd>call pum#map#confirm()<CR>' : '')
      \ .. '<Plug>(deol_execute_line)'

call ddc#custom#patch_filetype('deol', 'sourceOptions', #{
      \   _: #{
      \     converters: [],
      \   },
      \ })

autocmd UserCmd DirChanged <buffer>
      \ call deol#cd(v:event->get('cwd', getcwd()))
" }}}

" zsh {{{
inoreabbrev <buffer> g git
nnoremap <buffer> [Space]gc
      \ <Cmd>call deol#send('git commit')<CR>
nnoremap <buffer> [Space]gs
      \ <Cmd>call deol#send('git status')<CR>
nnoremap <buffer> [Space]gA
      \ <Cmd>call deol#send('git commit --amend')<CR>
" }}}
