return {
  'kosayoda/nvim-lightbulb',
  config = function()
    require('nvim-lightbulb').setup{
      sign = {
        enabled = false,
      },
      virtual_text = {
        enabled = true,
        pos = 0
      },
      autocmd = {
        enabled = true,
      }
    }
  end,
}
