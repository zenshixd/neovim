local M = require('lualine.component'):extend()

local get_branch_name_template =
[[jj bookmark list -r @-:: -T "concat(truncate_end(36, self.name()), \"\n\")" --quiet --ignore-working-copy]]

M.buf_to_branch = {}
M.init = function(self, options)
  M.super.init(self, options)

  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      self:update_branch_name()
    end
  })

  vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
      self:update_branch_name()
    end
  })
end


M.update_branch_name = function(self)
  local bufnr = vim.api.nvim_get_current_buf()

  local branches = vim.fn.system(get_branch_name_template)

  if vim.v.shell_error ~= 0 then
    vim.notify("Error getting branch", vim.log.levels.ERROR)
    vim.notify(branches, vim.log.levels.ERROR)
    return nil
  end

  local branch = vim.split(branches, "\n")[1]
  self.buf_to_branch[bufnr] = branch
end

M.update_status = function(self)
  local bufnr = vim.api.nvim_get_current_buf()
  return self.buf_to_branch[bufnr]
end

return M
