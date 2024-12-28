let g:mapleader = '\'
let g:maplocalleader = ','

nnoremap 	; 		<Nop>
nnoremap 	, 		<Nop>

" Use <C-Space>.
nmap            <C-Space>       <C-@>
cmap            <C-Space>       <C-@>

" Visual mode keymappings:
" Indent
nnoremap        >               >>
nnoremap        <               <<
xnoremap        >               >gv
xnoremap        <               <gv

if (!has('nvim') || $DISPLAY !=# '') && has('clipboard')
  xnoremap      y               "*y<Cmd>let [@+,@"]=[@*,@*]<CR>
endif

" Enable undo <C-w> and <C-u>.
inoremap        <C-w>           <C-g>u<C-w>
inoremap        <C-u>           <C-g>u<C-u>
inoremap        <C-k>           <C-o>D

" Command-line mode keymappings:
" <C-a>, A: move to head.
cnoremap        <C-a>           <Home>
" <C-b>: previous char.
cnoremap        <C-b>           <Left>
" <C-d>: delete char.
cnoremap        <C-d>           <Del>
" <C-f>: next char.
cnoremap        <C-f>           <Right>
" <C-n>: next history.
cnoremap        <C-n>           <Down>
" <C-p>: previous history.
cnoremap        <C-p>           <Up>
" <C-g>: Exit.
cnoremap        <C-g>           <C-c>
" <C-k>: Delete to the end.
cnoremap        <C-k>           <Cmd>call setcmdline(getcmdpos() ==# 1 ? '' : getcmdline()[:getcmdpos() - 2])<CR>

nmap 		<Space> 	[Space]
nnoremap 	[Space] 	<Nop>

nnoremap        [Space]p        <Cmd>call vimrc#toggle_option('spell')<CR>
                              \ <Cmd>set spelllang=en_us<CR>
                              \ <Cmd>set spelllang+=cjk<CR>
nnoremap        [Space]w        <Cmd>call vimrc#toggle_option('wrap')<CR>
nnoremap 	[Space]c	<Cmd>call <SID>toggle_conceal()<CR>
nnoremap	[Space]q	<Cmd>call vimrc#diagnostics_to_location_list()<CR>

" Easily edit current buffer
nnoremap        <expr> [Space]e '%'->bufname() !=# '' ? '<Cmd>edit %<CR>' : ''

" Quickfix
nnoremap        [Space]q        <Cmd>call vimrc#diagnostics_to_location_list()<CR>

" Useful save mappings.
nnoremap        <Leader><Leader> <Cmd>silent update<CR>

" s: Windows and buffers(High priority)
" The prefix key.
nnoremap        s               <Nop>
nnoremap        sp              <Cmd>vsplit<CR><Cmd>wincmd w<CR>
nnoremap        so              <Cmd>only<CR>
nnoremap        <Tab>           <cmd>wincmd w<CR>
nnoremap        <expr> q
      \   &l:filetype ==# 'qf'
      \ ? '<Cmd>cclose<CR><Cmd>lclose<CR>'
      \ : '#'->winnr()->getwinvar('&winfixbuf')
      \ ? ''
      \ : ('$'->winnr() > 2 <Bar><Bar>
      \    '#'->winnr()->winbufnr()->getbufvar('&filetype') !=# 'qf')
      \ ? '<Cmd>close<CR>'
      \ : ''

" Original search
nnoremap s/    /
nnoremap s?    ?

" Better x
nnoremap x "_x

" Disable Ex-mode.
nnoremap Q  q

" Useless command.
nnoremap M  m

" Smart <C-f>, <C-b>.
noremap <expr> <C-f> max([winheight(0) - 2, 1])
      \ .. '<C-d>' .. (line('w$') >= line('$') ? 'L' : 'M')
noremap <expr> <C-b> max([winheight(0) - 2, 1])
      \ .. '<C-u>' .. (line('w0') <= 1 ? 'H' : 'M')

" Disable ZZ.
nnoremap ZZ  <Nop>

" Select rectangle.
xnoremap r <C-v>

" Redraw.
nnoremap <C-l>    <Cmd>redraw!<CR>

" Easy escape.
inoremap jj           <ESC>
cnoremap <expr> j
      \ getcmdline()[getcmdpos()-2] ==# 'j' ? '<BS><C-c>' : 'j'

inoremap j<Space>     j

" Improved increment.
nnoremap <C-a> <Cmd>AddNumbers 1<CR>
nnoremap <C-x> <Cmd>AddNumbers -1<CR>
command! -range -nargs=1 AddNumbers
      \ call vimrc#add_numbers((<line2>-<line1>+1) * eval(<args>) * v:count1)

nnoremap #    <C-^>
" NOTE: Does not overwrite <ESC> behavior
if has('nvim')
  tnoremap jj          <C-\><C-n>
else
  tnoremap <ESC><ESC>  <C-l>N
  tnoremap jj          <C-l>N
endif
tnoremap j<Space>   j
tnoremap <expr> ;  vimrc#sticky_func()
tnoremap <C-y>      <C-r>+
" Tag jump
nnoremap tt  g<C-]>
nnoremap tp  <Cmd>pop<CR>

function s:toggle_conceal() abort
  if &l:conceallevel == 0
    setlocal conceallevel=3
  else
    setlocal conceallevel=0
  endif
  setlocal conceallevel?
endfunction

