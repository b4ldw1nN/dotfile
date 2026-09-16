local M = {}

function M.show()
  local status_ok, wk = pcall(require, "which-key")
  if not status_ok then
    vim.notify("which-key.nvim is not installed yet!", vim.log.levels.WARN)
    return
  end
  
  -- Open which-key showing all top-level keys (global & buffer-local)
  wk.show()
end

return M
