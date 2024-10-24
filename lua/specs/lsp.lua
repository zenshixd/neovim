return {
  { "nvim-lua/plenary.nvim" },
  { "nvimtools/none-ls.nvim", },
  { "nvimtools/none-ls-extras.nvim" },
  { 'echasnovski/mini.completion',  version = "*", config = true },
  { "williamboman/mason.nvim" },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      require 'mason'.setup {}
      local null_ls = require 'null-ls'
      local lspconfig = require 'lspconfig'

      lspconfig.ts_ls.setup {
        handlers = {
          ["textDocument/formatting"] = nil,
          ["textDocument/rangeFormatting"] = nil,
        }
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
      lspconfig.angularls.setup {
        root_dir = function(fname)
          return lspconfig.util.root_pattern("angular.json")(fname) or
              lspconfig.util.find_package_json_ancestor(fname) or
              lspconfig.util.find_git_ancestor(fname)
        end,
        handlers = {
          ["textDocument/codeAction"] = nil,
          ["textDocument/formatting"] = nil,
          ["textDocument/rangeFormatting"] = nil,
        }
      }
      lspconfig.zls.setup {
        on_attach = function()
          vim.g.zig_fmt_autosave = false
        end,
      }
      lspconfig.stylelint_lsp.setup {
        filetypes = { "css", "scss", "less", "sass" }
      }

      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.prettierd.with({
            name = "prettierxd",
            command = "prettierxd",
          }),
          null_ls.builtins.completion.spell,
          require("none-ls.diagnostics.eslint_d"),
          require("none-ls.code_actions.eslint_d"),
          require("none-ls.formatting.eslint_d"),
        },
      })
      vim.api.nvim_create_autocmd("BufWritePre", {
        callback = function()
          vim.lsp.buf.format()
        end,
      })
    end,
  }
}
