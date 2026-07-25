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

-- The colorscheme to use for each macOS appearance. Edit these to re-pair them;
-- `zenburned` comes from zenbones.nvim, `rose-pine` renders as `dawn` in light
-- via its `variant = "auto"` setting below.
local THEMES = {
  light = "rose-pine",
  dark = "zenburned",
}

-- The last appearance macOS reported. We react to the *system* changing, not to
-- `vim.o.background` merely disagreeing with it: picking a dark theme while macOS
-- is in light mode is a legitimate choice, but it reads as a mismatch and used to
-- get stomped on the next tick.
local last_system_background = get_system_background()

local function apply_theme(bg)
  vim.o.background = bg
  pcall(vim.cmd.colorscheme, THEMES[bg])
end

local function sync_theme_with_system()
  local bg = get_system_background()
  if bg == last_system_background then
    return
  end
  last_system_background = bg
  apply_theme(bg)
end

-- Neovim's default 'guicursor' only sends terminal cursor-color escape
-- codes for :terminal buffers (the "t:" mode below); normal/insert/visual/
-- cmdline cursors are left to the terminal emulator's own static color, so
-- they don't track the colorscheme at all. That's what made the cursor
-- disappear in floating inputs like neo-tree's rename/move/copy popup on
-- dark backgrounds. Appending "-Cursor" makes every mode push our own
-- Cursor highlight to the terminal instead.
vim.o.guicursor = "n-v-c-sm:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20-Cursor,t:block-blinkon500-blinkoff500-TermCursor"

local function set_cursor_highlight()
  -- Fixed, saturated color chosen to read clearly against every palette
  -- above (dark or light variants alike), rather than something derived
  -- per-theme that could end up low-contrast against a given background.
  vim.api.nvim_set_hl(0, "Cursor", { fg = "#1a1a1a", bg = "#ff4fa3" })
  vim.api.nvim_set_hl(0, "lCursor", { link = "Cursor" })
end

set_cursor_highlight()
vim.api.nvim_create_autocmd("ColorScheme", {
  desc = "Keep the cursor visible across every colorscheme/background",
  callback = set_cursor_highlight,
})

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

-- ZENBONES
--[[
-- vim.cmd("colorscheme zenbones") -- also: zenwritten, neobones, vimbones, rosebones, ...
--]]

-- TOKEN
--[[
-- vim.cmd("colorscheme token") -- respects vim.o.background automatically
--]]

-- ZENBURN
--[[
-- vim.cmd("colorscheme zenburn")
--]]

-- DUSK
--[[
-- vim.cmd("colorscheme dusk")
--]]

return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    -- zenburned (the dark-mode theme) ships with zenbones.nvim. Declared as a
    -- dependency rather than a sibling spec so lazy.nvim guarantees it is loaded
    -- before the config below applies a colorscheme at startup.
    dependencies = {
      { "zenbones-theme/zenbones.nvim", dependencies = { "rktjmp/lush.nvim" } },
    },
    config = function()
      require("rose-pine").setup({
        variant = "auto", -- follow vim.o.background; "dawn" would pin it regardless of background
        dark_variant = "moon",
        styles = { bold = true, italic = false, transparency = false },
      })

      last_system_background = get_system_background()
      apply_theme(last_system_background)

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

  { "ThorstenRhau/token", lazy = true },
  { "jnurmine/zenburn", lazy = true },
  { "fdemb/dusk.nvim", lazy = true, opts = {} },
}
