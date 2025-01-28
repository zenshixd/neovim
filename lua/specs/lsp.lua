return {
  { "nvim-lua/plenary.nvim" },
  { 'echasnovski/mini.completion', version = "*", config = true },
  { "williamboman/mason.nvim" },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      require 'mason'.setup {}
      local lspconfig = require 'lspconfig'
      local configs = require 'lspconfig.configs'

      if configs.prettierls == nil then
        configs.prettierls = require 'lspconfig.configs.prettierls'
      end

      lspconfig.vtsls.setup {
        on_init = function(client)
          client.server_capabilities.documentFormattingProvider = nil
          client.server_capabilities.documentRangeFormattingProvider = nil
        end,
      }

      lspconfig.lua_ls.setup {
        on_init = function(client)
          client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
            runtime = {
              version = "LuaJIT",
            },
            workspace = {
              library = {
                vim.env.VIMRUNTIME
              },
            },
          })
        end,
        settings = { Lua = {} },
      }

      lspconfig.jsonls.setup {}
      lspconfig.prettierls.setup {}
      lspconfig.eslint.setup {}

      lspconfig.angularls.setup {
        autostart = false,
        on_init = function(client)
          client.server_capabilities.codeActionProvider = nil
          client.server_capabilities.documentFormattingProvider = nil
          client.server_capabilities.documentRangeFormattingProvider = nil
        end,
        root_dir = function(fname)
          return lspconfig.util.root_pattern("angular.json")(fname) or
              lspconfig.util.find_package_json_ancestor(fname) or
              lspconfig.util.find_git_ancestor(fname)
        end,
      }

      lspconfig.zls.setup {
        on_attach = function()
          vim.g.zig_fmt_autosave = false
        end,
      }

      lspconfig.stylelint_lsp.setup {
        filetypes = { "css", "scss", "less", "sass" }
      }

      vim.api.nvim_create_autocmd("BufWritePre", {
        callback = function()
          vim.lsp.buf.format()
        end,
      })
    end,
  }
}
