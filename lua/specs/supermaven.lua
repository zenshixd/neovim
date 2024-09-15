return {
  "zenshixd/supermaven-nvim",
  branch = "popup-fix",
  config = true,
  cond = function() return vim.fn.getcwd():find('wkapp%-taskflow') == nil end,
}
