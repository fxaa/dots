let $CACHE = '~/.cache'->expand()
if !$CACHE->isdirectory()
  call mkdir($CACHE, 'p')
endif

function DppInitPlugin(plugin)
  " Search from $CACHE directory
  let dir = $CACHE .. '/dpp/repos/github.com/' .. a:plugin
  if !dir->isdirectory()
    " Install plugin automatically.
    execute '!git clone https://github.com/' .. a:plugin dir
  endif

  execute 'set runtimepath^='
        \ .. dir->fnamemodify(':p')->substitute('[/\\]$', '', '')
endfunction

call DppInitPlugin('Shougo/dpp.vim')
call DppInitPlugin('Shougo/dpp-ext-lazy')

" Set dpp base path (required)
const s:dpp_base = '~/.cache/dpp'->expand()
let $BASE_DIR = '<sfile>'->expand()->fnamemodify(':h')

function DppMakeState()
  call dpp#make_state(s:dpp_base, '$BASE_DIR/dpp.ts'->expand())
endfunction

if s:dpp_base->dpp#min#load_state()
  " NOTE: denops.vim and dpp plugins are must be added
  for s:plugin in [
        \   'Shougo/dpp-ext-installer',
        \   'Shougo/dpp-ext-local',
        \   'Shougo/dpp-ext-packspec',
        \   'Shougo/dpp-ext-toml',
        \   'Shougo/dpp-protocol-git',
        \   'vim-denops/denops.vim',
        \ ]
    call DppInitPlugin(s:plugin)
  endfor

  " NOTE: Manual load is needed for neovim
  " Because "--noplugin" is used to optimize.
  if has('nvim')
    runtime! plugin/denops.vim
  endif

  autocmd UserCmd User DenopsReady
        \ : echohl WarningMsg
        \ | echomsg 'dpp load_state() is failed'
        \ | echohl NONE
        \ | call DppMakeState()
else
  autocmd UserCmd BufWritePost *.lua,*.vim,*.toml,*.ts,vimrc,.vimrc
        \ call dpp#check_files()

  " Check new plugins
  autocmd UserCmd BufWritePost *.toml
        \ : if !dpp#sync_ext_action('installer', 'getNotInstalled')->empty()
        \ |  call dpp#async_ext_action('installer', 'install')
        \ | endif
endif

autocmd UserCmd User Dpp:makeStatePost
      \ : echohl WarningMsg
      \ | echomsg 'dpp make_state() is done'
      \ | echohl NONE
