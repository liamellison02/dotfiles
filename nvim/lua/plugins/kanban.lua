return {
  {
    "hasansujon786/super-kanban.nvim",
    cmd = "SuperKanban",
    ft = { "markdown" },
    init = function()
      -- auto-open board view for files named *board.md or with a
      -- `kanban-plugin:` frontmatter marker (obsidian compat).
      -- lives in init so it registers before the first buffer is read
      vim.api.nvim_create_autocmd("BufReadPost", {
        pattern = "*.md",
        group = vim.api.nvim_create_augroup("super_kanban_autoopen", { clear = true }),
        callback = function(ev)
          local name = vim.api.nvim_buf_get_name(ev.buf)
          local is_board = name:match("board%.md$") ~= nil
          if not is_board then
            for _, l in ipairs(vim.api.nvim_buf_get_lines(ev.buf, 0, 10, false)) do
              if l:match("^kanban%-plugin:") then
                is_board = true
                break
              end
            end
          end
          if not is_board then return end
          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(ev.buf) then
              require("super-kanban").open(name)
            end
          end)
        end,
      })
    end,
    opts = {
      markdown = {
        notes_dir = "./tasks/",
        list_heading = "h2",
        default_template = {
          "## Backlog\n",
          "## Todo\n",
          "## Work in progress\n",
          "## Completed\n",
        },
      },
      mappings = {
        -- flash jump between board windows
        ["s"] = {
          callback = function()
            require("flash").jump({
              search = { mode = "search", max_length = 0, multi_window = true },
              label = { after = { 0, 0 } },
              highlight = { backdrop = true, groups = { current = "FlashLabel", label = "FlashLabel" } },
              exclude = {
                function(win)
                  local kanban_ft = { superkanban_list = true, superkanban_card = true }
                  return not kanban_ft[vim.bo[vim.api.nvim_win_get_buf(win)].filetype]
                end,
              },
              matcher = function()
                return { { pos = { 1, 0 }, end_pos = { 1, 0 } } }
              end,
            })
          end,
          desc = "Flash",
        },
      },
    },
    keys = {
      { "<leader>K", "<cmd>SuperKanban open<cr>", desc = "Kanban board" },
    },
  },
}
