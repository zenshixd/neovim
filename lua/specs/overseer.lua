return {
  'stevearc/overseer.nvim',
  config = function()
    local overseer = require('overseer')
    overseer.setup {
      task_list = {
        min_height = 12,
      },
      component_aliases = {
        default = {
          { "display_duration", detail_level = 2 },
          "on_output_summarize",
          "on_exit_set_status",
          "on_complete_notify",
          "unique",
        }
      },
    }
    overseer.add_template_hook({ module = ".*" }, function(task_defn, util)
      --util.add_component(task_defn, { "unique" })
      --util.remove_component(task_defn, "on_complete_dispose")
    end)
  end,
}
