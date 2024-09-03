return {
  "sindrets/diffview.nvim",
  config = true,
  opts = {
    keymaps = {
      view = {
        { "n", "<C-c>", ":DiffviewClose<CR>", {desc = "Close the diff window"} },
      },
      file_panel = {
        { "n", "<C-c>", ":DiffviewClose<CR>", {desc = "Close the diff window"} },
      }
    }
  },
}
