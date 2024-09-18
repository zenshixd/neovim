return {
  "supermaven-inc/supermaven-nvim",
  config = true,
  cond = function() return vim.fn.getcwd():find('wkapp%-taskflow') == nil end,
}
