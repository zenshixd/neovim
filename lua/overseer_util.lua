local M = {}

function M.OverseerRun()
  local commands = require('overseer.commands')
  commands.run_template({ autostart = false }, function(task)
    M.OverseerSelectAction(task)
  end)
end

function M.OverseerSelectAction(task)
  local overseer = require('overseer')
  local action_util = require('overseer.action_util')
  local actions = {
    {
      name = "run",
      run = function()
        if task.status == overseer.constants.STATUS.SUCCESS or task.status == overseer.constants.STATUS.FAILURE then
          task:restart()
        else
          task:start()
        end
      end,
    },
    {
      name = "debug",
      run = function()
        action_util.run_task_action(task, "debug")
      end,
    }
  }

  vim.ui.select(actions, {
    prompt = "Select action to run: ",
    format_item = function(item)
      return item.name
    end,
  }, function(action)
    if action ~= nil then
      action.run()
    end
  end)
end

return M
