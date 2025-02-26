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
      templates = { 'shell', 'npm', 'jest', "zig" },
      actions = {
        debug = require('overseer.actions.debug'),
        update_snapshots = require('overseer.actions.update_snapshots'),
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
