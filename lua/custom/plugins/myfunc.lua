function RecycleTerminal()
  if vim.bo.buftype == 'terminal' then
    vim.cmd 'b#'
    return
  end
  local page_handle = vim.api.nvim_get_current_tabpage()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
      local term_tab_owner = -1
      pcall(function()
        term_tab_owner = vim.api.nvim_buf_get_var(buf, 'term_tab_owner')
      end)
      local num_windows = #vim.tbl_filter(function(win)
        return vim.api.nvim_win_get_buf(win) == buf
      end, vim.api.nvim_tabpage_list_wins(0))
      if num_windows == 0 and term_tab_owner == page_handle then
        vim.cmd('buffer ' .. vim.api.nvim_buf_get_name(buf))
        return buf
      end
    end
  end
  vim.cmd 'lcd %:p:h'
  vim.cmd 'terminal'
  vim.api.nvim_buf_set_var(0, 'term_tab_owner', page_handle)
end

function CreateTerminal()
  local page_handle = vim.api.nvim_get_current_tabpage()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local num_windows = #vim.tbl_filter(function(win)
      return vim.api.nvim_win_get_buf(win) == buf
    end, vim.api.nvim_tabpage_list_wins(0))
    if num_windows == 0 and term_tab_owner == page_handle then
      vim.cmd('buffer ' .. vim.api.nvim_buf_get_name(buf))
      return buf
    end
  end
  vim.cmd 'lcd %:p:h'
  vim.cmd 'terminal'
  vim.api.nvim_buf_set_var(0, 'term_tab_owner', page_handle)
end
