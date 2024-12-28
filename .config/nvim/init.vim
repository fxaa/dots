colorscheme nord

augroup UserCmd
  autocmd!
  autocmd FileType,Syntax,BufNewFile,BufNew,BufRead *?
  	\ call vimrc#on_filetype()
augroup END

try
  set cmdheight=0
  autocmd UserCmd CmdlineEnter,RecordingEnter * set cmdheight=1
  autocmd UserCmd CmdlineLeave,RecordingLeave * set cmdheight=0
catch
  set cmdheight=1
endtry

if has('nvim')
  set shada='100,<20,s10,h,r/tmp/,rterm:
  set foldcolumn=auto:1
  set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,
  	\i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
else
  set viminfo='100,<20,s10,h,r/tmp/
  set foldcolumn=1
endif

set title titlelen=95
" cwd (without '~' prefix), task name, & a dirty flag (+)
let &g:titlestring = [
      \   "%{'%:p:~:.'->expand()}",
      \   "%<\(%{getcwd()->fnamemodify(':~')}\)",
      \   "%(%y%m%r%)",
      \ ]->join()

const base_path = '<sfile>'->expand()->fnamemodify(':h')
execute 'source' base_path .. '/dpp.vim'

if !argv()->empty()
  call vimrc#on_filetype()
endif

set secure
