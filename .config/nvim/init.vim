colorscheme noirblaze

if &compatible
  set nocompatible
endif

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
  set foldcolumn=auto:1
else
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
  autocmd UserCmd CursorHold * call vimrc#on_filetype()
endif

set secure
