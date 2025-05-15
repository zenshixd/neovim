return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    image = { enabled = true },
    input = { enabled = true },
    picker = {
      enabled = true,
      ui_select = true,
      formatters = {
        file = {
          truncate = 80,
        }
      },
      layout = {
        layout = {
          box = "vertical",
          width = 0.8,
          min_width = 120,
          height = 0.8,
          min_height = 10,
          { win = "input",   height = 1,          border = "rounded" },
          { win = "list",    title = "{title}",   border = "rounded" },
          { win = "preview", title = "{preview}", border = "rounded" },
        },
      },
    },
  },
}
