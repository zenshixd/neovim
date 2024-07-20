require('config.lazy')
require("lsp-format").setup{}

require 'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "zig" },
  sync_install = false,
  auto_install = true,
  ignore_install = { "javascript" },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = false,
  }
}

require 'lspconfig'.zls.setup({
  on_attach = function(client, bufnr)
    require("lsp-format").on_attach(client, bufnr)
    vim.g.zig_fmt_autosave = false
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
    --    require("lsp-format").on_attach(client, bufnr)
  end
})

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.number = true
vim.opt.cursorline = true
--vim.api.nvim_create_autocmd("BufEnter", {
--  command = [[syn region myFold start="{" end="}" transparent fold]],
--})
--vim.opt.foldmethod = 'syntax'
--vim.opt.foldnestmax = 4
vim.opt.foldcolumn = '1'
vim.opt.foldmethod = 'manual'
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.g.zig_fmt_autosave = false

vim.cmd [[colorscheme dracula]]

function ToggleTerm()
  local wins = vim.api.nvim_list_wins()
  local term_window = nil
  for _, win in ipairs(wins) do
    local buf = vim.api.nvim_win_get_buf(win)
    local buf_title = vim.api.nvim_buf_get_name(buf)
    if buf_title:match("^term://") ~= nil then
      term_window = win
      break
    end
  end

  if term_window ~= nil then
    vim.api.nvim_set_current_win(term_window)
  else
    vim.api.nvim_command('bel :term powershell')
  end
end

vim.keymap.set('n', '<leader>t', ToggleTerm, {})
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')
vim.keymap.set('t', '<leader><Esc>', '<C-\\><C-n><C-w>k')
