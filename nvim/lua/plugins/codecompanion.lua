return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      interactions = {
        chat = {
          adapter = "openai_responses",
          model = "gpt-5.2",
        },
        inline = {
          adapter = "openai_responses",
          model = "gpt-5.2",
        },
      },
      adapters = {
        http = {
          openai_responses = function()
            return require("codecompanion.adapters").extend("openai_responses", {
              env = {
                api_key = "OPENAI_API_KEY",
              },
              schema = {
                model = { default = "gpt-5.2" },
              },
            })
          end,
        },
      },
    },
  },
}
