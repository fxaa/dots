if has('vim_starting') && argv()->empty()
  " dont load syntax if we might not need it
  syntax off
endif

" opt out of treesitter for perf sometimes
" https://github.com/neovim/neovim/pull/26347#issuecomment-1837508178
function s:config_treesitter()
  lua << END
  vim.treesitter.start = (function(wrapped)
    return function(bufnr, lang)
      local disabled_fts = {
        --'help',
      }
      local disabled_langs = {
        'vimdoc',
        'diff',
        'gitcommit',
        'swift',
        'latex',
      }
      local ft = vim.fn.getbufvar(bufnr or vim.fn.bufnr(''), '&filetype')
      if (vim.tbl_contains(disabled_fts, ft)
          or vim.tbl_contains(disabled_langs, lang)) then
        return
      end
      
      if bufnr then
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat,
            vim.api.nvim_buf_get_name(bufnr))
        if ok and stats and stats.size > max_filesize then
	  return
        end
      end

      wrapped(bufnr, lang)
    end
  end)(vim.treesitter.start)
END
endfunction

autocmd UserCmd Syntax * ++once call s:config_treesitter()
