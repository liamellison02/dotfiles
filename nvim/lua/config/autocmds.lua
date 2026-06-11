-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- PDF viewer: convert to text via pdftotext and open as a read-only buffer
vim.api.nvim_create_autocmd("BufReadCmd", {
  pattern = "*.pdf",
  callback = function()
    local path = vim.fn.expand("%:p")
    local buf = vim.api.nvim_get_current_buf()

    if vim.fn.executable("pdftotext") == 0 then
      vim.notify("pdftotext not found. Install with: brew install poppler", vim.log.levels.ERROR)
      return
    end

    local lines = vim.fn.systemlist("pdftotext -layout " .. vim.fn.shellescape(path) .. " -")

    if vim.v.shell_error ~= 0 then
      vim.notify("pdftotext failed for: " .. path, vim.log.levels.ERROR)
      return
    end

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].filetype = "text"
    vim.bo[buf].modifiable = false
    vim.bo[buf].readonly = true
    vim.bo[buf].swapfile = false
  end,
})
