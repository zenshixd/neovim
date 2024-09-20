return {
  "andythigpen/nvim-coverage",
  opts = {
    auto_reload = true,
    lang = {
      javascript = {
        coverage_file = function()
          local cur_dir = vim.fs.dirname(vim.fn.expand('%'))
          local result = vim.fs.find({ "coverage/lcov.info" }, { path = cur_dir, upward = true })
          if #result > 0 then
            return result[1]
          end
        end
      }
    }
  },
  config = true,
}
