require('config.lazy')
require('lsp-format').setup {}
local null_ls = require('null-ls')
null_ls.setup({
  sources = {
    null_ls.builtins.formatting.prettierd,
    require("none-ls.diagnostics.eslint_d"),
  },
  on_attach = function(client, bufnr)
    require("lsp-format").on_attach(client, bufnr)
  end
})

require("persisted").setup({
  autostart = true,
  autoload = true,
  use_git_branch = true,
  on_autoload_no_session = function()
    vim.notify("No existing session to load.")
  end
})
require 'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "zig", "typescript", "javascript", "json", "json5" },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = false,
  }
}
require 'mason'.setup()
require 'mason-lspconfig'.setup()

require("mason-lspconfig").setup_handlers {
  function(server_name)    -- default handler (optional)
    require("lspconfig")[server_name].setup {
      on_init = function()
        vim.g.zig_fmt_autosave = false
      end,
    }
  end,
  ["lua_ls"] = function()
    require("lspconfig").lua_ls.setup {
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
require('overseer').setup{}

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.foldcolumn = '1'
vim.opt.foldmethod = 'manual'
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.g.zig_fmt_autosave = false

vim.cmd [[colorscheme dracula]]

vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')
vim.keymap.set('n', '<F12>', ':OverseerToggle bottom<CR>')
vim.keymap.set('n', '<leader>qq', ':qa<CR>')
vim.keymap.set('n', '<leader>cc', ':OverseerRun<cr>')
vim.keymap.set('n', '<leader>cs', ':OverseerRunCmd<cr>')
vim.keymap.set("n", "<C-,>", ':BufferPrevious<CR>')
vim.keymap.set("n", "<C-.>", ':BufferNext<cr>')
vim.keymap.set('n', '<C-q>', ':BufferClose<cr>')
