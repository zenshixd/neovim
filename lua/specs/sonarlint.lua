return {
  url = "https://gitlab.com/schrieveslaach/sonarlint.nvim.git",
  event = "VeryLazy",
  config = function()
    require("sonarlint").setup({
    server = {
      cmd = {
        'sonarlint-language-server',
        -- Ensure that sonarlint-language-server uses stdio channel
        '-stdio',
        '-analyzers',
        -- paths to the analyzers you need, using those for python and java in this example
        vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjs.jar"),
        vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarhtml.jar"),
      }
   },
   filetypes = {
     "javascript",
     "typescript",
     "html",
   },
  })
  end,
  dependencies = {
    "neovim/nvim-lspconfig",
  }
}
