local overseer = require('overseer')
local files = require('overseer.files')

function pick_package_manager()
  local cur_dir = vim.fn.expand('%:p')
  local opts = { path = cur_dir, upward = true }
  local found_lockfiles = vim.fs.find({ "yarn.lock", "pnpm-lock.yaml", "package-lock.json" }, opts)
  local filename = vim.fs.basename(found_lockfiles[1])

  if filename == 'yarn.lock' then
    return 'yarn'
  elseif filename == 'pnpm-lock.yaml' then
    return 'pnpm'
  elseif filename == 'package-lock.json' then
    return 'npm'
  end

  return nil
end

return {
  generator = function(_, cb)
    local tasks = {}
    local pckg_json = vim.fs.find({ "package.json" }, { path = vim.fs.dirname(vim.fn.expand('%:p')), upward = true })
    if #pckg_json == 0 then
      cb({})
      return
    end

    local data = files.load_json_file(pckg_json[1])
    local path = os.getenv("PATH") or ""
    local paths = vim.split(path, ":")
    local mgr = pick_package_manager()
    local mgr_path

    for _, v in pairs(paths) do
      local files_found = vim.fs.find({ mgr }, { path = v, limit = 1 })
      if #files_found ~= 0 then
        mgr_path = files_found[1]
        break
      end
    end

    if mgr_path == nil then
      cb({})
      return
    end

    table.insert(tasks, {
      name = mgr,
      tags = { overseer.TAG.RUN },
      priority = 60,
      builder = function()
        return {
          cmd = { "node" },
          args = { mgr_path },
          name = mgr,
          cwd = vim.fs.dirname(pckg_json[1]),
          components = { "default", "on_complete_dispose" },
        }
      end,
    })
    if data.scripts ~= nil then
      for k, _ in pairs(data.scripts) do
        table.insert(tasks, {
          name = mgr .. " " .. k,
          tags = { overseer.TAG.RUN },
          priority = 60,
          builder = function()
            return {
              cmd = { "node" },
              args = { mgr_path, k },
              name = mgr .. " " .. k,
              cwd = vim.fs.dirname(pckg_json[1]),
              components = { "default", "on_complete_dispose" },
            }
          end,
        })
      end
    end

    cb(tasks)
  end,
  condition = {
    callback = function()
      return pick_package_manager() ~= nil
    end,
  }
}
