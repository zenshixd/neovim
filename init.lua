require('config.lazy')
require("lsp-format").setup {

}

require 'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "zig" },
  sync_install = false,
  auto_install = true,
  ignore_install = { "javascript" },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}

require 'lspconfig'.zls.setup({
  on_attach = function(client, bufnr)
    --    require("lsp-format").on_attach(client, bufnr)
  end
})
require 'lspconfig'.lua_ls.setup({
  on_init = function(client, bufnr)
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
  settings = {
    Lua = {},
  },
  on_attach = function(client, bufnr)
    require("lsp-format").on_attach(client, bufnr)
  end
})

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldnestmax = 4
vim.opt.foldtext = "'[+] '.getline(v:foldstart)"

vim.cmd [[colorscheme dracula]]

function ToggleTerm()
  vim.api.nvim_command('bel :term')
end

vim.keymap.set('n', '<leader>tt', ToggleTerm, {})
vim.keymap.set('t', '<Esc>', '<C-\\><C-n><C-w>k')
