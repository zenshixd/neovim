return {
  { "nvim-lua/plenary.nvim" },
  { "nvimtools/none-ls.nvim", },
  { "nvimtools/none-ls-extras.nvim" },
  { 'echasnovski/mini.completion',      version = "*", config = true },
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  { "lukas-reineke/lsp-format.nvim" },
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    config = true,
    opts = {
      symbol_in_winbar = {
        enable = false,
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
    },
    config = function()
      local null_ls = require('null-ls')
      local lsp_format = require('lsp-format')
      local lspconfig = require('lspconfig')

      lsp_format.setup {
        sync = true,
      }
      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.prettierd,
          null_ls.builtins.completion.spell,
          require("none-ls.diagnostics.eslint_d"),
          require("none-ls.code_actions.eslint_d"),
          require("none-ls.formatting.eslint_d"),
        },
        on_attach = function(client, bufnr)
          lsp_format.on_attach(client, bufnr)
        end
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
        function(server_name) -- default handler (optional)
          lspconfig[server_name].setup {
            on_init = function()
              vim.g.zig_fmt_autosave = false
            end,
            on_attach = lsp_format.on_attach,
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
          }
        end,
      }

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client ~= nil and client.name == "angularls" then
            client.server_capabilities.codeActionProvider = nil
          end
        end,
      })
    end,
  }
}
