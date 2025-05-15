return {
  'akinsho/bufferline.nvim',
  version = "*",
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    vim.opt.termguicolors = true
    require('bufferline').setup {
      options = {
        style_preset = require('bufferline').style_preset.no_bold,
        truncate_names = false,
        show_buffer_close_icons = false,
        show_close_icon = false,
        separator_style = "thin",
        diagnostics = "nvim_lsp",
        custom_filter = function(buf_number)
          local buftype = vim.api.nvim_get_option_value('buftype', { buf = buf_number })
          if buftype == "quickfix" then
            return false
          end
          return true
        end,
      }
    }
  end
}
