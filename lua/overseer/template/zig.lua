local overseer = require('overseer')
return {
  generator = function(_, cb)
    local test_filename = vim.fn.expand('%:t:r')
    local test_filter = test_filename .. ".test"

    local tasks = {}
    local test_cwd = vim.fs.root(0, "build.zig")

    table.insert(tasks, {
      name = "zig build test -Dfilter=" .. test_filter,
      tags = { overseer.TAG.TEST },
      priority = 1,
      builder = function()
        return {
          cmd = { 'zig' },
          args = { 'build', 'test', '-Dfilter=' .. test_filter },
          name = "zig build test -Dfilter=" .. test_filter,
          cwd = test_cwd,
          components = { "default", "on_complete_dispose" },
        }
      end,
    })

    table.insert(tasks, {
      name = "zig build test",
      tags = { overseer.TAG.TEST },
      priority = 2,
      builder = function()
        return {
          cmd = { 'zig' },
          args = { 'build', 'test' },
          name = "zig build test",
          cwd = test_cwd,
          components = { "default", "on_complete_dispose" },
        }
      end,
    })

    cb(tasks)
  end,
  condition = {
    filetype = { "zig" },
  }
}
