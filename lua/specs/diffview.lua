return {
  "sindrets/diffview.nvim",
  config = true,
  opts = {
    keymaps = {
      view = {
        { "n", "q", ":DiffviewClose<CR>", {desc = "Close the diff window"} },
      },
      file_panel = {
        { "n", "q", ":DiffviewClose<CR>", {desc = "Close the diff window"} },
      }
    }
  },
}
