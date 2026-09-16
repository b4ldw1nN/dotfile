local keymap = vim.keymap.set
local opts = { silent = true }

-- Clear search highlight (with Escape or Leader + h)
keymap("n", "<Esc>", ":nohlsearch<CR>", { desc = "Clear search highlights", silent = true })
keymap("n", "<Leader>h", ":nohlsearch<CR>", { desc = "Clear search highlights", silent = true })

-- Split Windows
keymap("n", "<Leader>v", ":vsplit<CR>", { desc = "Split vertically", silent = true })
keymap("n", "<Leader>s", ":split<CR>", { desc = "Split horizontally", silent = true })

-- Move between splits using Ctrl + hjkl
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize splits using Ctrl + Arrow keys
keymap("n", "<C-Up>", ":resize +2<CR>", { desc = "Resize split up", silent = true })
keymap("n", "<C-Down>", ":resize -2<CR>", { desc = "Resize split down", silent = true })
keymap("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Resize split left", silent = true })
keymap("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Resize split right", silent = true })

-- Buffer Navigation
keymap("n", "<Tab>", ":bnext<CR>", { desc = "Next buffer", silent = true })
keymap("n", "<S-Tab>", ":bprevious<CR>", { desc = "Previous buffer", silent = true })

-- Close Buffer
keymap("n", "<Leader>c", ":bdelete<CR>", { desc = "Close buffer", silent = true })

-- Fast Write/Quit
keymap("n", "<Leader>w", ":w<CR>", { desc = "Save file", silent = true })
keymap("n", "<Leader>q", ":q<CR>", { desc = "Quit window", silent = true })
keymap("n", "<Leader>Q", ":qa!<CR>", { desc = "Force quit all", silent = true })

-- Fast start and end of line navigation (H and L)
keymap({ "n", "v" }, "H", "^", { desc = "Go to start of line", silent = true })
keymap({ "n", "v" }, "L", "$", { desc = "Go to end of line", silent = true })

-- Keep search results centered on the screen
keymap("n", "n", "nzzzv", opts)
keymap("n", "N", "Nzzzv", opts)

-- Keep screen centered when scrolling half page down/up
keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)

-- Paste over selected text in visual mode without overwriting clipboard (paste register)
keymap("x", "p", '"_dP', opts)

-- Stay in visual mode when indenting
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move selected lines up/down in Visual mode
keymap("x", "J", ":m '>+1<CR>gv=gv", { desc = "Move lines down", silent = true })
keymap("x", "K", ":m '<-2<CR>gv=gv", { desc = "Move lines up", silent = true })

-- Custom Cheatsheet Trigger (F2 or Leader + ?)
keymap("n", "<F2>", function() require("cheatsheet").show() end, { desc = "Show cheatsheet menu", silent = true })
keymap("n", "<Leader>?", function() require("cheatsheet").show() end, { desc = "Show cheatsheet menu", silent = true })

-- --- User Requested Shortcuts ---

-- 1. Copying to System Clipboard
keymap({ "n", "v" }, "<Leader>y", '"+y', { desc = "Copy to system clipboard" })
keymap("n", "<Leader>Y", '"+Y', { desc = "Copy line to system clipboard" })

-- 2. Deleting Without Copying
keymap({ "n", "v" }, "<Leader>x", '"_d', { desc = "Delete without copying" })

-- 3. Moving lines up/down (Alt + j/k)
keymap("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down", silent = true })
keymap("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up", silent = true })
keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down", silent = true })
keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up", silent = true })
keymap("i", "<A-j>", "<Esc>:m .+1<CR>==gi", { desc = "Move line down", silent = true })
keymap("i", "<A-k>", "<Esc>:m .-2<CR>==gi", { desc = "Move line up", silent = true })
