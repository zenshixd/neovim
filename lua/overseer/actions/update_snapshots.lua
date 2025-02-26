local overseer = require 'overseer'

return {
  desc = "Update snapshots",
  condition = function()
    return true
  end,
  run = function(task)
    local old_cmd = task.cmd
    task.cmd = vim.list_extend(task.cmd, { '-Dupdate' })
    if task.status == overseer.STATUS.SUCCESS or task.status == overseer.STATUS.FAILURE then
      task:restart()
    else
      task:start()
    end
    task.cmd = old_cmd
  end,
}
