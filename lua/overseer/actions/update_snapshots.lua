return {
  desc = "Update snapshots",
  condition = function(task)
    return true
  end,
  run = function(task)
    local overseer = require 'overseer'
    local old_cmd = task.cmd
    task.cmd = vim.list_extend(vim.deepcopy(task.cmd), { "-Dupdate" })
    if task.status == overseer.STATUS.SUCCESS or task.status == overseer.STATUS.FAILURE or task.status == overseer.STATUS.CANCELED then
      task:restart()
    else
      task:start()
    end
    task.cmd = old_cmd
  end,
}
