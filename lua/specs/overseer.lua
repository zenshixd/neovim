return {
  'stevearc/overseer.nvim',
  branch = 'master',
  config = function()
    local overseer = require('overseer')
    overseer.setup {
      dap = true,
      templates = { 'builtin', 'jest', "zig" },
      component_aliases = {
        default = {
          { "display_duration", detail_level = 2 },
          "on_output_summarize",
          "on_exit_set_status",
          "on_complete_notify",
          "unique",
          { "open_output",      on_start = "always", focus = true, direction = "float" },
        },
      }
    }
  end,
}
