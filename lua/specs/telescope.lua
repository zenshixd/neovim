return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  init = function()
    local builtin = require('telescope.builtin')
    local telescope = require('telescope')
    telescope.load_extension('persisted')
  end
}
