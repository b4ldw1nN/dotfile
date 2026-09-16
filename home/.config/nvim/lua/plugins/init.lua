return {
  -- Rose Pine pastel theme (replaces Catppuccin)
  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
    lazy = false,
    config = function()
      require('rose-pine').setup({
        variant = "moon", -- pastel variant
      })
      vim.cmd "colorscheme rose-pine"
    end,
  },

  -- Transparent background (optional)
  {
    "xiyaowong/transparent.nvim",
    lazy = false,
    config = function()
      require("transparent").setup {
        enable = true,
        extra_groups = {},
        exclude = {},
      }
    end,
  },

  -- Which-Key: Interactive Keybinding Helper
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      local wk = require("which-key")
      wk.setup({
        plugins = {
          presets = {
            operators = false,
            motions = false,
            text_objects = false,
            windows = false,
            nav = false,
            z = false,
            g = false,
          },
        },
        win = {
          border = "single",
          wo = {
            winblend = 10,
          },
        },
      })
      -- Register leader key group labels for suggestions
      wk.add({
        { "<leader>f", group = "Find" },
        { "<leader>g", group = "Git" },
        { "<leader>r", group = "Refactor" },
        { "<leader>c", group = "Close" },
      })
    end,
  },

  -- Mini Icons (resolves which-key warning)
  {
    "echasnovski/mini.icons",
    lazy = false,
  },

  -- Nvim-Tree: Fast File Explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<Leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle File Explorer" },
    },
    opts = {
      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = true,
      },
      hijack_directories = {
        enable = true,
        auto_open = true,
      },
      view = {
        width = 30,
      },
      renderer = {
        group_empty = true,
      },
    },
  },

  -- Telescope: Fuzzy Finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<Leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find Files" },
      { "<Leader>fg", function() require("telescope.builtin").live_grep() end, desc = "Find Words (Grep)" },
      { "<Leader>fw", function() require("telescope.builtin").grep_string() end, desc = "Find Current Word" },
      { "<Leader>fb", function() require("telescope.builtin").buffers() end, desc = "List Buffers" },
      { "<Leader>fz", function() require("telescope.builtin").current_buffer_fuzzy_find() end, desc = "Search Current Buffer" },
      { "<Leader>fh", function() require("telescope.builtin").help_tags() end, desc = "Help Tags" },
      { "<Leader>fo", function() require("telescope.builtin").oldfiles() end, desc = "Recent Files" },
    },
    opts = {
      defaults = {
        path_display = { "truncate" },
        sorting_strategy = "ascending",
        layout_config = {
          horizontal = { prompt_position = "top", preview_width = 0.55 },
        },
      },
    },
  },

  -- Lualine: Sleek Statusline with pastel theme
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {
      options = {
        theme = "rose-pine",
        section_separators = "",
        component_separators = "",
      },
    },
  },

  -- Treesitter: Parser-based Syntax Highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSUpdate", "TSInstall" },
    config = function(_, opts)
      local status, configs = pcall(require, "nvim-treesitter.configs")
      if not status then return end
      configs.setup(opts)
    end,
    opts = {
      ensure_installed = { "lua", "vim", "vimdoc", "javascript", "typescript", "python", "html", "css", "markdown", "json", "c", "cpp", "rust", "go", "bash" },
      highlight = { enable = true },
      indent = { enable = true },
    },
  },

  -- LSP Config, Mason, and Mason-LSPConfig
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local has_mason, mason = pcall(require, "mason")
      local has_mason_lspconfig, mason_lspconfig = pcall(require, "mason-lspconfig")
      local has_lspconfig, lspconfig = pcall(require, "lspconfig")
      if not (has_mason and has_mason_lspconfig and has_lspconfig) then
        return
      end

      mason.setup()
      
      local on_attach = function(_, bufnr)
        local opts = { buffer = bufnr, silent = true }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
        vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Go to references" }))
        vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover Documentation" }))
        vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
        vim.keymap.set("n", "<Leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code Action" }))
        vim.keymap.set("n", "<Leader>d", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Show diagnostics" }))
      end
      
      local has_cmp_lsp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      local capabilities = has_cmp_lsp and cmp_lsp.default_capabilities() or vim.lsp.protocol.make_client_capabilities()
      
      mason_lspconfig.setup({
        ensure_installed = {
          "lua_ls",          -- Lua
          "pyright",         -- Python
          "ts_ls",           -- Javascript / Typescript
          "html",            -- HTML
          "cssls",           -- CSS
          "jsonls",          -- JSON
          "clangd",          -- C / C++
          "rust_analyzer",   -- Rust
          "gopls",           -- Go
          "bashls",          -- Bash / Shell
          "marksman",        -- Markdown
        },
        handlers = {
          function(server_name)
            lspconfig[server_name].setup({
              on_attach = on_attach,
              capabilities = capabilities,
            })
          end,
        },
      })
    end,
  },

  -- Nvim-CMP: Autocompletion
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local has_cmp, cmp = pcall(require, "cmp")
      local has_luasnip, luasnip = pcall(require, "luasnip")
      if not (has_cmp and has_luasnip) then
        return
      end
      
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })

      -- Autocompletion for search '/'
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      -- Autocompletion for command ':'
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })
    end,
  },

  -- Gitsigns: Git integration in gutter
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local has_gs, gs = pcall(require, "gitsigns")
      if not has_gs then return end
      gs.setup({
        on_attach = function(bufnr)
          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end
          map("n", "]g", gs.next_hunk, { desc = "Next Git Hunk" })
          map("n", "[g", gs.prev_hunk, { desc = "Previous Git Hunk" })
          map("n", "<Leader>gp", gs.preview_hunk, { desc = "Preview Git Hunk" })
          map("n", "<Leader>gb", function() gs.blame_line({ full = true }) end, { desc = "Blame Git Line" })
        end
      })
    end,
  },

  -- Autopairs: Auto-close parenthesis
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  -- Todo Comments: Highlight TODO / FIXME
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },

  -- Flash: Quick Screen Jump Navigation
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    },
  },

  -- Colorizer: Display hex/rgb colors dynamically
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      filetypes = { "*" },
      user_default_options = {
        RGB = true,
        RRGGBB = true,
        names = true,
        css = true,
        mode = "background",
      },
    },
  },

  -- Alpha: Beautiful Dashboard
  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VimEnter",
    config = function()
      local has_alpha, alpha = pcall(require, "alpha")
      local has_dashboard, dashboard = pcall(require, "alpha.themes.dashboard")
      if not (has_alpha and has_dashboard) then return end
      
      -- Three Katanas — Santoryu
     dashboard.section.header.val = {
    "       ▓█▄                                 ▄█▓",
    "       ▓███▄                             ▄███▓",
    "       ▓█████▄                         ▄█████▓",
    "       ▒███████▄                     ▄███████▒",
    "       ▒█████████▄                 ▄█████████▒",
    "       ░█████▀█████▄             ▄█████▀█████░",
    "       ░█████  ▀█████▄         ▄█████▀  █████░",
    "        █████    ▀█████▄     ▄█████▀    █████",
    "        █████      ▀█████   █████▀      █████",
    "        █████   █▄   ▀███▄▄███▀   ▄█    █████",
    "        █████   ███▄   ▀███▀   ▄███     █████",
    "        █████   █████▄   ▀   ▄█████     █████",
    "        ▒████   ███████     ███████     ████▒",
    "        ▒████   ██████▀     ▀██████     ████▒",
    "         ▓███   █████▀  ▄█▄  ▀█████    ███▓",
    "          ▓██   ███▀   █████   ▀███    ██▓",
    "           ▀█   █▀     ▀███▀     ▀█    █▀",
    }
    dashboard.section.header.opts.hl = "Special"
      
      -- Setup quick links with colors
      dashboard.section.buttons.val = {
        dashboard.button("f", "  Find File", "<cmd>lua require('telescope.builtin').find_files()<CR>"),
        dashboard.button("r", "  Recent Files", "<cmd>lua require('telescope.builtin').oldfiles()<CR>"),
        dashboard.button("g", "  Find Text", "<cmd>lua require('telescope.builtin').live_grep()<CR>"),
        dashboard.button("o", "  Open Folder", "<cmd>lua vim.ui.input({ prompt = 'Open Folder: ', default = vim.fn.getcwd() .. '/', completion = 'dir' }, function(input) if input and input ~= '' then local path = vim.fn.expand(input); if vim.fn.isdirectory(path) == 1 then vim.cmd.cd(vim.fn.fnameescape(path)); require('nvim-tree.api').tree.open({ path = path }); elseif vim.fn.filereadable(path) == 1 then vim.cmd.edit(vim.fn.fnameescape(path)); end end end)<CR>"),
        dashboard.button("e", "  New File", "<cmd>ene <BAR> startinsert<CR>"),
        dashboard.button("c", "  Configuration", "<cmd>e ~/.config/nvim/init.lua<CR>"),
        dashboard.button("q", "󰅚  Quit", "<cmd>qa<CR>"),
      }
      
      -- Apply elegant highlights to buttons
      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "Keyword"
        button.opts.hl_shortcut = "Number"
      end
      
      -- Set dynamic loaded plugins and startuptime stats footer
      dashboard.section.footer.val = function()
        local stats = require("lazy").stats()
        local count = stats.count
        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
        return "⚡ Loaded " .. count .. " plugins in " .. ms .. "ms"
      end
      dashboard.section.footer.opts.hl = "Constant"
      
      alpha.setup(dashboard.opts)
    end,
  },

  -- Bufferline: Elegant tabs for open files
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function(_, opts)
      local status, bufferline = pcall(require, "bufferline")
      if not status then return end
      bufferline.setup(opts)
    end,
    opts = {
      options = {
        mode = "buffers",
        diagnostics = "nvim_lsp",
        separator_style = "thin",
        show_buffer_close_icons = true,
        show_close_icon = false,
        always_show_bufferline = true,
      },
    },
  },

  -- Indent Blankline: Visual indentation guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },

  -- Visual Multi: Multiple cursors / carets
  {
    "mg979/vim-visual-multi",
    event = { "BufReadPost", "BufNewFile" },
  },

  -- Glow: Preview markdown directly inside a Neovim floating window
  {
    "ellisonleao/glow.nvim",
    config = true,
    cmd = "Glow",
    ft = { "markdown" },
  },

  -- Noice: Floating command-line popup + better messages
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      cmdline = {
        enabled = true,
        view = "cmdline",
        format = {
          cmdline = { icon = "❯" },
          search_down = { icon = "🔍⌄" },
          search_up = { icon = "🔍⌃" },
          filter = { icon = "$" },
          lua = { icon = "☾" },
          help = { icon = "?" },
        },
      },
      messages = {
        enabled = true,
        view = "mini",
      },
      popupmenu = {
        enabled = true,
        backend = "nui",
      },
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
    },
  },
}
