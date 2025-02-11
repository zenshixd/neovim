local overseer = require('overseer')
local utils = require('overseer.template.utils')


local test_query = [[
(test_declaration
  (string) @test-name) @scope-root
]]

return {
  generator = function(search, cb)
    local test_filename = vim.fn.expand('%:t:r')
    local test_filter = test_filename .. ".test"

    local tasks = {}
    local test_cwd = vim.fs.root(0, "build.zig")

    local result = utils.find_nearest_test(search.filetype, test_query)

    if #result > 0 then
      local single_test_filter = test_filter .. "." .. result[1]
      table.insert(tasks, {
        name = "zig build test -Dfilter=" .. single_test_filter,
        tags = { overseer.TAG.TEST },
        priority = 1,
        builder = function()
          return {
            cmd = { 'zig' },
            args = { 'build', 'test', '-Dfilter=' .. single_test_filter },
            name = "zig build test -Dfilter=" .. single_test_filter,
            cwd = test_cwd,
            components = { "default", "on_complete_dispose" },
          }
        end,
      })
    end

    table.insert(tasks, {
      name = "zig build test -Dfilter=" .. test_filter,
      tags = { overseer.TAG.TEST },
      priority = 2,
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
      priority = 3,
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

    table.insert(tasks, {
      name = "zig build test -Dupdate",
      tags = { overseer.TAG.TEST },
      priority = 3,
      builder = function()
        return {
          cmd = { 'zig' },
          args = { 'build', 'test', '-Dupdate' },
          name = "zig build test -Dupdate",
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
