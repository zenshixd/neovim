return {
  "supermaven-inc/supermaven-nvim",
  opts = {
    ignore_filetypes = { "DressingInput" },
  },
  cond = function()
    return vim.fn.getcwd():find('wkapp%-taskflow') == nil
  end,
}
