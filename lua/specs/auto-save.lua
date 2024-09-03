return {
  "pocco81/auto-save.nvim",
  opts = {
    trigger_events = { "InsertLeave" },
    condition = function() return vim.bo.filetype ~= "OverseerForm" end
  }
}
