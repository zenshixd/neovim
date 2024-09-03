return {
  "supermaven-inc/supermaven-nvim",
  init = function()
    require("supermaven-nvim").setup({})
  end,
  cond = function() return vim.fn.getcwd():find('wkapp%-taskflow') == nil end,
}
