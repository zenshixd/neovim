return {
  { "nvim-lua/plenary.nvim" },
  {
    'echasnovski/mini.completion',
    version = false,
    opts = {},
  },
  { "williamboman/mason.nvim" },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      require 'mason'.setup {}
      local lspconfig = require 'lspconfig'

      lspconfig.vtsls.setup {
        on_init = function(client)
          client.server_capabilities.documentFormattingProvider = nil
          client.server_capabilities.documentRangeFormattingProvider = nil
        end,
      }

      lspconfig.lua_ls.setup {}
      lspconfig.jsonls.setup {
        init_options = {
          provideFormatter = false,
        }
      }
      lspconfig.eslint.setup {}
      lspconfig.cssls.setup {
        init_options = {
          provideFormatter = false,
        }
      }

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

      vim.lsp.enable({
        "prettierls"
      })

      vim.api.nvim_create_autocmd("BufWritePre", {
        callback = function()
          vim.lsp.buf.format()
        end,
      })

      vim.api.nvim_create_autocmd("Filetype", {
        pattern = "snacks_picker_input,snacks_input,dap-repl,OverseerForm",
        callback = function()
          vim.b.minicompletion_disable = true
        end,
      })

      -- vim.api.nvim_create_autocmd("LspAttach", {
      --   callback = function(event)
      --     local client_id = event.data.client_id
      --     vim.lsp.completion.enable(true, client_id, 0, {
      --       autotrigger = true,
      --     })
      --   end
      -- })
    end,
  }
}
