return {
  'stevearc/overseer.nvim',
  config = function()
    local overseer = require('overseer')
    overseer.setup{}
    overseer.add_template_hook({ module = ".*" }, function(task_defn, util)
      util.add_component(task_defn, { "unique" })
      util.remove_component(task_defn, "on_complete_dispose")
    end)
  end,
}
