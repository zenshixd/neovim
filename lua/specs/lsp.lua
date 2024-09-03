return {
  "neovim/nvim-lspconfig",
  lazy = false,
  dependencies = {
    { "nvimtools/none-ls.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
    { "nvimtools/none-ls-extras.nvim", dependencies = { "nvimtools/none-ls.nvim" } },
    { "ms-jpq/coq_nvim", branch = "coq" },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    { "lukas-reineke/lsp-format.nvim" },
  },
  init = function()
    vim.g.coq_settings = {
      auto_start = true,
      ["clients.tree_sitter.enabled"] = false,
      ["clients.buffers.enabled"] = false,
      keymap = {
        recommended = false,
      }
    }
    vim.api.nvim_set_keymap('i', '<Esc>', [[pumvisible() ? "\<C-e>" : "\<Esc>"]], { expr = true, silent = true })
    vim.api.nvim_set_keymap('i', '<C-c>', [[pumvisible() ? "\<C-e><C-c>" : "\<C-c>"]], { expr = true, silent = true })
    vim.api.nvim_set_keymap('i', '<BS>', [[pumvisible() ? "\<C-e><BS>" : "\<BS>"]], { expr = true, silent = true })
    vim.api.nvim_set_keymap(
      "i",
      "<CR>",
      [[pumvisible() ? (complete_info().selected == -1 ? "\<C-e><CR>" : "\<C-y>") : "\<CR>"]],
      { expr = true, silent = true }
    )
  end,
  config = function()
    local null_ls = require('null-ls')
    local lsp_format = require('lsp-format')
    local lspconfig = require('lspconfig')

    lsp_format.setup {}
    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.prettierd,
        require("none-ls.diagnostics.eslint_d"),
      },
      on_attach = function(client, bufnr)
        lsp_format.on_attach(client, bufnr)
      end
    })
    require 'mason'.setup()
    require("mason-lspconfig").setup_handlers {
      function(server_name)    -- default handler (optional)
        lspconfig[server_name].setup {
          on_init = function()
            vim.g.zig_fmt_autosave = false
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
    }
    lspconfig.angularls.setup{
      root_dir = function(fname)
        return lspconfig.util.root_pattern("angular.json")(fname) or lspconfig.util.find_package_json_ancestor(fname) or lspconfig.util.find_git_ancestor(fname)
      end,
    }
  end,
}
