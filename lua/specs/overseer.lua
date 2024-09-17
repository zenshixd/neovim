return {
  'stevearc/overseer.nvim',
  config = function()
    local overseer = require('overseer')
    overseer.setup {
      templates = { 'builtin', 'jest' },
      task_list = {
        min_width = 60,
      },
      component_aliases = {
        default = {
          { "display_duration",    detail_level = 2 },
          "on_output_summarize",
          "on_exit_set_status",
          "on_complete_notify",
          { "on_complete_dispose", require_view = { "SUCCESS", "FAILURE" } },
          "unique"
        },
      }
    }
  end,
}
