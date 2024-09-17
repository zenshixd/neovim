local overseer = require('overseer')
local test_utils = require('overseer.template.utils')

local jest_test_query = [[
  ((expression_statement
    (call_expression
      function: (identifier) @method-name
      (#match? @method-name "^(describe|test|it)")
      arguments: (arguments [
        ((string) @test-name)
        ((template_string) @test-name)
      ]
    )))
  @scope-root)
]]

return {
  generator = function(search, cb)
    local jest_configs = {
      "jest.config.js",
      "jest.config.cjs",
      "jest.config.mjs",
      "jest.config.ts",
    }
    local jest_cwd = vim.fs.root(0, jest_configs) or vim.fs.root(0, "package.json")
    local config_path = vim.fs.find(jest_configs, { path = jest_cwd })
    local test_file = vim.fn.expand('%:t')

    local tasks = {}
    local nearest_tests = test_utils.find_nearest_test(search.filetype, jest_test_query)
    if #nearest_tests > 0 then
      for _, test in ipairs(nearest_tests) do
        table.insert(tasks, {
          name = "Run test " .. test_file .. ' -> ' .. test,
          tags = { overseer.TAG.TEST },
          priority = 0,
          builder = function()
            return {
              cmd = { './node_modules/.bin/jest' },
              args = { '--config=' .. vim.fs.basename(config_path[1]), '--testPathPattern=' .. test_file, '--testNamePattern=' .. test },
              name = test_file .. ' -> ' .. test,
              cwd = jest_cwd,
              components = { "default" },
            }
          end,
        })
      end
    end

    table.insert(tasks, {
      name = "Run all tests in current file",
      tags = { overseer.TAG.TEST },
      priority = 1,
      builder = function()
        return {
          cmd = { './node_modules/.bin/jest' },
          args = { '--config=' .. vim.fs.basename(config_path[1]), '--testPathPattern=' .. test_file },
          name = test_file,
          cwd = jest_cwd,
          components = { "default" },
        }
      end,
    })

    cb(tasks)
  end,
  condition = {
    filetype = { "javascript", "typescript" },
    callback = function()
      local file = vim.fn.expand('%:t')

      return file:match('%.test%.[jt]sx?$') ~= nil or file:match('%.spec%.[jt]sx?$') ~= nil
    end,
  }
}

