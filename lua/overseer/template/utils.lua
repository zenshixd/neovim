local ts = vim.treesitter
local ts_utils = require('nvim-treesitter.ts_utils')

local M = {}

-- @param filetype: string
-- @param test_query: string
function M.find_nearest_test(filetype, test_query)
  local query = ts.query.parse(filetype, test_query)
  local result = {}
  if query then
    local curnode = ts_utils.get_node_at_cursor()

    while curnode do
      local iter = query:iter_captures(curnode, 0)
      local capture_id, capture_node = iter()

      if capture_node == curnode and query.captures[capture_id] == "scope-root" then
        while query.captures[capture_id] ~= "test-name" do
          capture_id, capture_node = iter()
          if not capture_id then
            return result
          end
        end
        local name = ts.get_node_text(capture_node, 0)
        name = string.gsub(name, "${.*}", "(.*)")
        name = string.sub(name, 2, -2)
        table.insert(result, 1, name)
      end

      curnode = curnode:parent()
    end
  end
  return result
end

return M
