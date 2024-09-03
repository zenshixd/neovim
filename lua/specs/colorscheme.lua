return {
  "ellisonleao/gruvbox.nvim",
  config = function()
    require('gruvbox').setup{
      contrast = 'hard',
    }
    vim.o.background = 'light'
    vim.cmd [[colorscheme gruvbox]]
  end
}
