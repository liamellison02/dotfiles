-- Disable spell checking for markdown buffers.
-- This runs after LazyVim's ftplugin, overriding its `setlocal spell = true`.
vim.opt_local.spell = false

-- Markdown formatting shortcuts (visual mode, buffer-local)
-- `c` cuts the selection into register ", then we rebuild it wrapped in markers.
local map = vim.keymap.set
local opts = { buffer = true, desc = "" }

opts.desc = "Bold"
map("v", "<D-b>", "c**<C-r>\"**<Esc>", opts)

opts.desc = "Italic"
map("v", "<D-i>", "c*<C-r>\"*<Esc>", opts)

opts.desc = "Strikethrough"
map("v", "<D-s>", "c~~<C-r>\"~~<Esc>", opts)
