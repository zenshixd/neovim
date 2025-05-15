local overseer = require 'overseer'
local conf_mapping = {
  node = function(task)
    local old_cmd = task.cmd
    task.cmd = vim.list_extend({ 'node', '--inspect-brk' }, vim.list_slice(task.cmd, 2))
    if task.status == overseer.STATUS.SUCCESS or task.status == overseer.STATUS.FAILURE or task.status == overseer.STATUS.CANCELED then
      task:restart()
    else
      task:start()
    end
    require 'dap'.run({
      type = 'pwa-node',
      request = 'attach',
      name = 'Debug node',
      cwd = task.cwd,
      continueOnAttach = true,
    })
    task.cmd = old_cmd
  end,
  zig = function(task)
    local old_cmd = task.cmd
    task.cmd = vim.list_extend(vim.list_slice(task.cmd, 1), { "-Ddebug" })
    if task.status == overseer.STATUS.SUCCESS or task.status == overseer.STATUS.FAILURE or task.status == overseer.STATUS.CANCELED then
      task:restart()
    else
      task:start()
    end
    task.cmd = old_cmd
  end,
}


return {
  desc = "Debug task using DAP",
  condition = function(task)
    return true
  end,
  run = function(task)
    local debug_fn = conf_mapping[task.cmd[1]]
    if debug_fn ~= nil then
      return debug_fn(task)
    end

    vim.notify("No debug function found for " .. vim.inspect(task.cmd), vim.log.levels.WARN)
  end,
}
