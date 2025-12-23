return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_by_name = {},
        never_show = {},
      },
      -- optional: if you use "follow current file"
      -- follow_current_file = { enabled = true },
    },
  },
}
