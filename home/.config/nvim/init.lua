-- Set map leader keys before lazy.nvim to ensure proper mapping registration
vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.opt.wildmenu = true

-- Load core configurations
require("options")
require("keymaps")
require("commands")

-- Bootstrap lazy.nvim (package manager)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
vim.opt.wildmode = { "list:longest", "full" }

-- Initialize lazy.nvim and load the plugins list
require("lazy").setup("plugins", {
  change_detection = {
    notify = false, -- disable notifications when config changes
  },
})
