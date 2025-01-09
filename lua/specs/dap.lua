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
  end,
}
