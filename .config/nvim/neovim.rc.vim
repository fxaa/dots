if has('vim_starting') && argv()->empty()
  " dont load syntax if we might not need it
  syntax off
endif

" opt out of treesitter for perf sometimes
" https://github.com/neovim/neovim/pull/26347#issuecomment-1837508178
function s:intercept_treesitter()
  lua << END
  vim.treesitter.start = (function(wrapped)
    return function(bufnr, lang)
      local ft = vim.fn.getbufvar(
        bufnr or vim.fn.bufnr(''),
	'&filetype'
      )
      local check = (
        ft == 'help' or lang == 'vimdoc' or lang == 'diff'
	or lang == 'gitcommit' or lang == 'swift' or lang == 'latex'
      )
      if check then
	return
      end

      local max_filesize = 100 * 1024 -- 100 kib
      local ok, stats = pcall(vim.loop.fs_stat,
          vim.api.nvim_buf_get_name(bufnr))
      if ok and stats and stats.size > max_filesize then
	return
      end

      wrapped(bufnr, lang)
    end
  end)(vim.treesitter.start)
END
endfunction

autocmd UserCmd Syntax * ++once call s:intercept_treesitter()
