-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

map("n", "<leader>aa", "<cmd>CodeCompanionChat<cr>", { desc = "AI Chat" })
map("v", "<leader>aa", "<cmd>CodeCompanionChat<cr>", { desc = "AI Chat (selection)" })
map("v", "<leader>ae", "<cmd>CodeCompanion<cr>", { desc = "AI Inline Edit" })

map("n", "<leader>ut", function()
  vim.cmd("Telescope colorscheme")
end, { desc = "Switch colorscheme" })
