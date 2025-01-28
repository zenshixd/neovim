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
      command = vim.fn.stdpath('data') .. '/mason/packages/codelldb/extension/adapter/codelldb.exe',
    }

    dap.configurations.zig = {
      {
        name = "Launch zig program",
        type = "codelldb",
        request = "launch",
        cwd = "${workspaceFolder}",
        program = function()
          return vim.fn.input('Path to program: ', vim.fn.getcwd() .. '/', 'file')
        end,
        stopOnEntry = true,
        -- args = { "build", "run", "${file}", "--", "--interactive" },
        -- sourceLanguages = ["zig"],
        -- noDebug = true,
        -- trace = true,
      }
    }
  end,
}
