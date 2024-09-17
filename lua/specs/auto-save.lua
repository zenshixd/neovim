return {
  "pocco81/auto-save.nvim",
  opts = {
    trigger_events = { "InsertLeave" },
    condition = function(buf)
      return vim.api.nvim_buf_is_valid(buf) and vim.bo.filetype ~= "OverseerForm" and vim.bo.buftype ~= "nofile" and
      vim.bo.buftype ~= "prompt"
    end
  }
}
