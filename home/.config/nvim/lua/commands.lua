local cmd = vim.api.nvim_create_user_command

-- Toggle Lualine visibility
cmd('LualineToggle', function()
  local ok, lualine = pcall(require, 'lualine')
  if not ok then
    vim.notify('Lualine not loaded', vim.log.levels.ERROR)
    return
  end
  if vim.g.lualine_visible == nil then vim.g.lualine_visible = true end
  if vim.g.lualine_visible then
    lualine.hide()
    vim.g.lualine_visible = false
    vim.notify('Lualine hidden')
  else
    lualine.show()
    vim.g.lualine_visible = true
    vim.notify('Lualine shown')
  end
end, {})

-- Show current Lualine visibility status
cmd('LualineStatus', function()
  local status = (vim.g.lualine_visible == nil or vim.g.lualine_visible) and 'shown' or 'hidden'
  vim.notify('Lualine is currently ' .. status)
end, {})

-- Toggle File Explorer
cmd('ExplorerToggle', function()
  vim.cmd 'NvimTreeToggle'
end, { desc = 'Toggle NvimTree file explorer' })

-- Toggle Git Blame on current line
cmd('GitBlameToggle', function()
  local ok, gs = pcall(require, 'gitsigns')
  if not ok then
    vim.notify('Gitsigns not loaded', vim.log.levels.ERROR)
    return
  end
  gs.toggle_current_line_blame()
end, { desc = 'Toggle inline git blame' })

-- Toggle Indent Guides
cmd('IndentToggle', function()
  vim.cmd 'IBLToggle'
end, { desc = 'Toggle indent-blankline guides' })

-- List all loaded plugins
cmd('PluginsList', function()
  local loaded = vim.tbl_keys(package.loaded)
  table.sort(loaded)
  for _, name in ipairs(loaded) do
    print(name)
  end
end, { desc = 'Print all loaded Lua modules' })

-- Show startup time and plugin count
cmd('StartupInfo', function()
  local stats = require('lazy').stats()
  vim.notify(string.format('⚡ %d plugins loaded in %.2fms', stats.count, stats.startuptime))
end, { desc = 'Show startup time and plugin count' })

-- Show all TODO/FIXME/HACK comments (requires todo-comments.nvim)
cmd('Todos', function()
  local ok, _ = pcall(vim.cmd, 'TodoTelescope')
  if not ok then
    vim.notify('todo-comments or telescope not available', vim.log.levels.WARN)
  end
end, { desc = 'Search TODO/FIXME/HACK comments' })

-- Quick health check
cmd('Health', function()
  vim.cmd 'checkhealth'
end, { desc = 'Run :checkhealth' })

-- Reload the entire Neovim config
cmd('ReloadConfig', function()
  vim.cmd 'source $MYVIMRC'
  vim.notify('Config reloaded!')
end, { desc = 'Reload init.lua and all config' })

-- Auto-change directory when opening Neovim with a directory argument (e.g. nvim ~/.config/hypr)
local function check_and_cd_dir()
  local target = ""
  if vim.fn.argc() > 0 then
    target = vim.fn.argv(0)
  end
  if target == "" then
    target = vim.api.nvim_buf_get_name(0)
  end
  if target ~= "" then
    local path = vim.fn.expand(target)
    if vim.fn.isdirectory(path) == 1 then
      pcall(vim.api.nvim_set_current_dir, path)
    end
  end
end

check_and_cd_dir()

vim.api.nvim_create_autocmd({ "VimEnter", "BufEnter" }, {
  group = vim.api.nvim_create_augroup("AutoCdDirectory", { clear = true }),
  once = true,
  callback = check_and_cd_dir,
})

