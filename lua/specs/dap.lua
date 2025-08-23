return {
  {
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
          name = "Debug program",
          type = "codelldb",
          request = "launch",
          cwd = "${workspaceFolder}",
          program = "${workspaceFolder}/zig-out/bin/${workspaceFolderBasename}",
        },
        {
          name = "Debug test",
          type = "codelldb",
          request = "launch",
          cwd = "${workspaceFolder}",
          program = "${workspaceFolder}/zig-out/bin/test",
          initCommands = { "settings set target.process.follow-fork-mode child" },
        },
        {
          name = "Attach",
          type = "codelldb",
          request = "attach",
          cwd = "${workspaceFolder}",
          pid = function()
            return vim.fn.input("Process ID: ")
          end,
        }
      }
    end,
  },
  {
    'theHamsta/nvim-dap-virtual-text',
    opts = {},
  }
}
