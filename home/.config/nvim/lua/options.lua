local opt = vim.opt

-- Disable hit-enter prompts
opt.more = false

-- Line Numbers
opt.number = true
opt.relativenumber = true

-- Tabs & Indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- Search Defaults
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- UI Settings
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true

-- Ensure CursorLine uses a background highlight instead of an underline
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "CursorLine", { bg = "#313244", underline = false })
  end,
})

opt.scrolloff = 8
opt.sidescrolloff = 8
opt.mouse = "a"
opt.showmode = false -- Lualine handles this visually
opt.showcmd = false   -- Hide partial key sequences (leader key etc.) from command line
opt.cmdheight = 1     -- Bottom command line for clean command writing

-- System Clipboard
opt.clipboard = "unnamedplus"

-- Splits Layout
opt.splitright = true
opt.splitbelow = true

-- Performance & Gutter Updates
opt.updatetime = 250
opt.timeoutlen = 300
opt.swapfile = false  -- Disable swap files (undofile handles persistent undo/session history)

-- Undodir and backupdir (ensure they exist)
opt.undodir = vim.fn.stdpath('config') .. '/undodir'
opt.backupdir = vim.fn.stdpath('config') .. '/backup'
vim.cmd('silent! call mkdir(opt.undodir, "p")')
vim.cmd('silent! call mkdir(opt.backupdir, "p")')

-- Remember undos across sessions
opt.undofile = true

-- Disable diagnostic underlines globally (errors/warnings will still show in gutter signs and float)
vim.diagnostic.config({
  underline = false,
})

-- Automatically open side-by-side auto-reloading Glow preview for markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    -- Ignore terminal buffers
    if vim.bo.buftype == "terminal" then
      return
    end

    -- Check if a preview window already exists in the current tabpage
    local preview_exists = false
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      local ok, val = pcall(vim.api.nvim_win_get_var, win, "is_markdown_preview")
      if ok and val == 1 then
        preview_exists = true
        break
      end
    end
    if preview_exists then
      return
    end

    local file_path = vim.fn.expand("%:p")
    if file_path == "" then
      return
    end

    -- Save current window to return focus to it later
    local current_win = vim.api.nvim_get_current_win()

    -- Open vertical split on the right
    vim.cmd("rightbelow vsplit")
    local preview_win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_var(preview_win, "is_markdown_preview", 1)

    -- Clean window options for a cleaner preview look
    vim.wo[preview_win].number = false
    vim.wo[preview_win].relativenumber = false
    vim.wo[preview_win].signcolumn = "no"

    -- Launch auto-reloading glow terminal
    local cmd = string.format(
      "terminal sh -c 'last=\"\"; while true; do if [ ! -f %s ]; then sleep 1; continue; fi; curr=$(stat -c %%Y %s); if [ \"$curr\" != \"$last\" ]; then clear; glow %s; last=\"$curr\"; fi; sleep 0.5; done'",
      vim.fn.shellescape(file_path),
      vim.fn.shellescape(file_path),
      vim.fn.shellescape(file_path)
    )
    vim.cmd(cmd)

    -- Return focus to the original file buffer
    vim.api.nvim_set_current_win(current_win)
  end,
})
