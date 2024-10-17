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
        args = { '/Users/ownelek/.local/share/nvim/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js', '${port}' },
      },
    }
    local nodeDapConfig = {
      {
        type = 'pwa-node',
        request = 'launch',
        name = 'Debug node',
        program = '${file}',
        cwd = '${workspaceFolder}',
        sourceMaps = true,
      },
      {
        type = 'pwa-node',
        request = 'attach',
        name = 'Attach to Designer',
        cwd = '${workspaceFolder}',
        websocketAddress = 'ws://127.0.0.1:9250',
      }
    }
    dap.configurations.javascript = nodeDapConfig
    dap.configurations.typescript = nodeDapConfig
  end,
}
