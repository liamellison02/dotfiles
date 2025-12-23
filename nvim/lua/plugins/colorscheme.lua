-- GLOBALS
-- vim.o.background = "light"

-- ROSE PINE
-- require("rose-pine").setup({
--   variant = "dawn",
--   dark_variant = "moon",
--   styles = {
--     bold = true,
--     italic = false,
--     transparency = false,
--   },
-- })
-- vim.cmd("colorscheme rose-pine")
--
-- EVERFOREST
--[[
-- vim.g.everforest_background = "soft" -- soft | medium | hard
-- vim.g.everforest_ui_contrast = "low"
-- vim.cmd("colorscheme everforest")
--]]

-- GRUVBOX
--[[
--require("gruvbox").setup({
--  contrast = "soft",
--  transparent_mode = false,
--})
--vim.cmd("colorscheme gruvbox")
]]

-- NOCTIS
-- [[
--vim.cmd("colorscheme noctis")
-- ]]

return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    config = function()
      vim.o.background = "light"
      require("rose-pine").setup({
        variant = "dawn",
        dark_variant = "moon",
        styles = { bold = true, italic = false, transparency = false },
      })
      vim.cmd.colorscheme("rose-pine")
    end,
  },

  { "sainnhe/everforest", lazy = true },
  { "ellisonleao/gruvbox.nvim", lazy = true },
  { "talha-akram/noctis.nvim", lazy = true },
}
