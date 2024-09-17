return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  init = function()
    local builtin = require('telescope.builtin')
    local telescope = require('telescope')
    telescope.load_extension('persisted')
  end,
  opts = {
    defaults = {
      layout_strategy = "vertical",
      layout_config = {
        prompt_position = "top",
        mirror = true,
        width = 0.8,
        height = 0.6,
      },
    },
    pickers = {
      oldfiles = {
        cwd_only = true,
      },
    },
  },
}
