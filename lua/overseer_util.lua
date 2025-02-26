local M = {}

function M.OverseerRun()
  local commands = require('overseer.commands')
  local template = require('overseer.template')
  template.list({
    dir = vim.fn.getcwd(),
    filetype = vim.bo.filetype,
  }, function(templates)
    local templ_params = { autostart = false }
    if #templates == 0 then
      templ_params = { name = "shell", params = {} }
    end

    commands.run_template(templ_params, M.OverseerSelectAction)
  end)
end

function M.OverseerSelectAction(task)
  if task == nil then
    return
  end

  local overseer = require('overseer')
  local action_util = require('overseer.action_util')
  local actions = {
    {
      name = "run",
      run = function()
        if task.status == overseer.constants.STATUS.SUCCESS or task.status == overseer.constants.STATUS.FAILURE or task.status == overseer.constants.STATUS.CANCELED then
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

  if task.name:match("^zig build test") ~= nil then
    table.insert(actions, {
      name = "update snapshots",
      run = function()
        action_util.run_task_action(task, "update_snapshots")
      end,
    })
  end

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
