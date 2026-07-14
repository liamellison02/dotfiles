-- GLOBALS
-- vim.o.background = "light"

-- Detect macOS system appearance so the colorscheme can follow it.
local function get_system_background()
  local ok, result = pcall(vim.fn.system, "defaults read -g AppleInterfaceStyle 2>/dev/null")
  if ok and result:match("Dark") then
    return "dark"
  end
  return "light"
end

local function sync_theme_with_system()
  local bg = get_system_background()
  if vim.o.background ~= bg then
    vim.o.background = bg
    vim.cmd.colorscheme("rose-pine")
  end
end

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
      require("rose-pine").setup({
        variant = "auto", -- follow vim.o.background; "dawn" would pin it regardless of background
        dark_variant = "moon",
        styles = { bold = true, italic = false, transparency = false },
      })

      vim.o.background = get_system_background()
      vim.cmd.colorscheme("rose-pine")

      -- Neovim has no event for "system appearance changed", so poll for it
      -- and also recheck whenever the terminal regains focus.
      local timer = vim.uv.new_timer()
      timer:start(5000, 5000, vim.schedule_wrap(sync_theme_with_system))

      vim.api.nvim_create_autocmd("FocusGained", {
        group = vim.api.nvim_create_augroup("sync_theme_with_system", { clear = true }),
        callback = sync_theme_with_system,
      })
    end,
  },

  { "sainnhe/everforest", lazy = true },
  { "ellisonleao/gruvbox.nvim", lazy = true },
  { "talha-akram/noctis.nvim", lazy = true },
}
