return {
  'mfussenegger/nvim-dap',
  version = false,
  branch = 'master',
  config = function()
    local dap = require('dap')
    dap.adapters['pwa-node'] = {
      type = 'server',
      host = 'localhost',
      port = '${port}',
      executable = {
        command = 'node',
        args = { vim.fn.stdpath('data') .. '/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js', '${port}' },
      },
    }

    dap.adapters.codelldb = {
      type = "executable",
      command = vim.fn.stdpath('data') .. '/mason/packages/codelldb/extension/adapter/codelldb',
    }

    dap.configurations.zig = {
      {
        name = "Launch zig program",
        type = "codelldb",
        request = "launch",
        cwd = "${workspaceFolder}",
        program = function()
          local args = vim.fn.input("Build args: ")
          local cmd = "zig build test:artifact"
          if args ~= "" then
            cmd = cmd .. " " .. args
          end
          local result = vim.fn.system(cmd)

          if vim.v.shell_error ~= 0 then
            vim.notify("Error building zig program", vim.log.levels.ERROR)
            vim.notify(result, vim.log.levels.ERROR)
            return
          end

          return result:gsub("%s+", "")
        end,
      }
    }
  end,
}
