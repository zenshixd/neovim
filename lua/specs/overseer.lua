return {
  'stevearc/overseer.nvim',
  branch = 'master',
  config = function()
    local overseer = require('overseer')
    overseer.setup {
      task_list = {
        min_height = 16,
      },
      dap = true,
      templates = { 'npm', 'jest', "zig" },
      actions = {
        debug = require('overseer.actions.debug'),
        watch = false,
      },
      component_aliases = {
        default = {
          { "display_duration", detail_level = 2 },
          "on_output_summarize",
          "on_exit_set_status",
          "on_complete_notify",
          "unique",
          { "open_output",      on_start = "always" },
        },
      }
    }
  end,
}
