return {
  { "nvim-lua/plenary.nvim" },
  { "nvimtools/none-ls.nvim", },
  { "nvimtools/none-ls-extras.nvim" },
  { 'echasnovski/mini.completion',      version = "*", config = true },
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    config = true,
    opts = {
      symbol_in_winbar = {
        enable = false,
      },
      lightbulb = {
        enable = true,
        sign = true,
        sign_priority = 40,
        virtual_text = false,
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local null_ls = require('null-ls')
      local lspconfig = require('lspconfig')

      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.prettierd,
          null_ls.builtins.completion.spell,
          require("none-ls.diagnostics.eslint_d"),
          require("none-ls.code_actions.eslint_d"),
          require("none-ls.formatting.eslint_d"),
        },
      })
      require 'mason'.setup()
      require("mason-lspconfig").setup {
        ensure_installed = {
          "ts_ls",
          "angularls",
          "lua_ls",
          "zls",
        },
      }
      require("mason-lspconfig").setup_handlers {
        function(server_name)
          lspconfig[server_name].setup {
            on_init = function()
              vim.g.zig_fmt_autosave = false
            end,
          }
        end,
        ["ts_ls"] = function()
          lspconfig.ts_ls.setup {
            on_attach = function(client)
              client.server_capabilities.documentFormattingProvider = nil
              client.server_capabilities.documentRangeFormattingProvider = nil
            end,
          }
        end,
        ["lua_ls"] = function()
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
        end,
        ['angularls'] = function()
          lspconfig.angularls.setup {
            root_dir = function(fname)
              return lspconfig.util.root_pattern("angular.json")(fname) or
                  lspconfig.util.find_package_json_ancestor(fname) or
                  lspconfig.util.find_git_ancestor(fname)
            end,
            on_attach = function(client, bufnr)
              client.server_capabilities.codeActionProvider = nil
              client.server_capabilities.documentFormattingProvider = nil
              client.server_capabilities.documentRangeFormattingProvider = nil
            end,
          }
        end,
      }

      vim.api.nvim_create_autocmd("BufWritePre", {
        callback = function()
          vim.lsp.buf.format()
        end,
      })
    end,
  }
}
