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
      local function is_node_modules(bufnr)
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        return bufname:find("node_modules") ~= nil
      end

      vim.lsp.config("eslint", {
        handlers = {
          ["textDocument/diagnostic"] = function(err, result, ctx)
            if err ~= nil and err.code == -32603 then
              vim.notify("Failed to get ESLint configuration, stopping server", vim.log.levels.WARN, {})
              local client = vim.lsp.get_client_by_id(ctx.client_id)
              if client == nil then
                vim.notify("Failed to stop ESLint server", vim.log.levels.ERROR, {})
                return
              end

              client:stop(false)
              return
            end

            vim.lsp.handlers["textDocument/diagnostic"](err, result, ctx)
          end,
        }
      })

      require 'mason'.setup {}
      vim.lsp.config('vtsls', {
        settings = {
          typescript = {
            format = {
              enable = false,
            },
          },
          javascript = {
            format = {
              enable = false,
            },
          },
        },
      })
      vim.lsp.config('angularls', {
        capabilities = {
          textDocument = {
            formatting = nil,
            rangeFormatting = nil,
          }
        }
      })
      vim.lsp.config('stylelint_lsp', {
        init_options = {
          filetypes = { "css", "scss", "less", "sass" },
        }
      })
      vim.lsp.config('jsonls', {
        provideFormatter = false,
      })
      vim.lsp.config('cssls', {
        init_options = {
          provideFormatter = false,
        }
      })
      vim.lsp.enable({
        "stylelint_lsp",
        -- "angularls",
        "cssls",
        "jsonls",
        "lua_ls",
        "eslint",
        "vtsls",
        "zls",
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
    end,
  }
}
