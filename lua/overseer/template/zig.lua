local overseer = require('overseer')
local utils = require('overseer.template.utils')


local test_query = [[
(test_declaration
  (string) @test-name) @scope-root
]]

local main_fn_query = [[
(function_declaration
  name: (identifier) @function-name
  (#eq? @function-name "main"))
]]

function has_main_fn(filetype)
  local ts = vim.treesitter
  local query = ts.query.parse(filetype, main_fn_query)
  local tree = ts.get_parser():parse()[1]:root()
  local iter = query:iter_captures(tree:root(), 0)

  return iter() ~= nil
end

local cached_steps = nil
local cached_steps_mtime = nil
function list_build_steps()
  if cached_steps ~= nil and cached_steps_mtime ~= nil then
    local mtime = vim.fn.getftime(vim.fs.joinpath(vim.fn.getcwd(), "build.zig"))
    if mtime == cached_steps_mtime then
      return cached_steps
    end
  end

  vim.notify("Retrieving zig build steps", vim.log.levels.WARN)
  local result = vim.fn.system("zig build --help")
  local lines = vim.split(result, "\n")
  local reading_steps = false
  local steps = {}
  for _, line in ipairs(lines) do
    if reading_steps then
      if line == "" then
        reading_steps = false
      else
        local parts = vim.split(line, " ", { trimempty = true })
        table.insert(steps, parts[1])
      end
    end

    if line:find("Steps:") ~= nil then
      reading_steps = true
    end
  end

  cached_steps = steps
  cached_steps_mtime = vim.fn.getftime(vim.fs.joinpath(vim.fn.getcwd(), "build.zig"))
  return steps
end

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

    for i, step in ipairs(list_build_steps()) do
      table.insert(tasks, {
        name = "zig build " .. step,
        tags = { overseer.TAG.BUILD },
        priority = 10 + i,
        builder = function()
          return {
            cmd = { 'zig' },
            args = { 'build', step },
            name = "zig build " .. step,
            cwd = test_cwd,
            components = { "default", "on_complete_dispose" },
          }
        end,
      })
    end

    if has_main_fn(search.filetype) then
      local cur_file = vim.fn.expand('%:.')
      table.insert(tasks, {
        name = "zig run " .. cur_file,
        tags = { overseer.TAG.RUN },
        priority = 20,
        builder = function()
          return {
            cmd = { 'zig' },
            args = { 'run', cur_file },
            name = "zig run " .. cur_file,
            cwd = test_cwd,
            components = { "default", "on_complete_dispose" },
          }
        end,
      })
    end

    cb(tasks)
  end,
  condition = {
    filetype = { "zig" },
  },
}
