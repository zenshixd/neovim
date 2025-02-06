return {
  "nvim-lualine/lualine.nvim",
  opts = {
    options = {
      theme = require('lualine.themes.onenord_light'),
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { { "filename", path = 1 } },
      lualine_c = {
        "diff",
        {
          "diagnostics",
          sources = { "nvim_lsp", "nvim_diagnostic" },
        }
      },
      lualine_x = { "jj" },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
    extensions = { "oil", "overseer", "quickfix" },
  },
}
