 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#1a1110',
    base01 = '#271d1c',
    base02 = '#322826',
    base03 = '#a08c89',
    base04 = '#d8c2be',
    base05 = '#f1dfdc',
    base06 = '#f1dfdc',
    base07 = '#f1dfdc',
    base08 = '#ffb4ab',
    base09 = '#dec48c',
    base0A = '#e7bdb6',
    base0B = '#ffb4a8',
    base0C = '#dec48c',
    base0D = '#ffb4a8',
    base0E = '#e7bdb6',
    base0F = '#93000a',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  hi('TelescopeNormal',         { fg = '#f1dfdc',          bg = '#1a1110' })
  hi('TelescopeBorder',         { fg = '#a08c89',             bg = '#1a1110' })
  hi('TelescopePromptNormal',   { fg = '#f1dfdc',          bg = '#1a1110' })
  hi('TelescopePromptBorder',   { fg = '#a08c89',             bg = '#1a1110' })
  hi('TelescopePromptPrefix',   { fg = '#ffb4a8',             bg = '#1a1110' })
  hi('TelescopePromptCounter',  { fg = '#d8c2be',  bg = '#1a1110' })
  hi('TelescopePromptTitle',    { fg = '#1a1110',             bg = '#ffb4a8' })
  hi('TelescopePreviewTitle',   { fg = '#1a1110',             bg = '#e7bdb6' })
  hi('TelescopeResultsTitle',   { fg = '#1a1110',             bg = '#dec48c' })
  hi('TelescopeSelection',      { fg = '#f1dfdc',          bg = '#322826' })
  hi('TelescopeSelectionCaret', { fg = '#ffb4a8',             bg = '#322826' })
  hi('TelescopeMatching',       { fg = '#ffb4a8',             bold = true })
end

 -- Register a signal handler for SIGUSR1 (matugen updates)
 local signal = vim.uv.new_signal()
 signal:start(
   'sigusr1',
   vim.schedule_wrap(function()
     package.loaded['matugen'] = nil
     require('matugen').setup()
   end)
 )

 return M
