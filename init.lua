require('config.lazy')
require("lsp-format").setup {}

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
      on_attach = function(client, bufnr)
        require("lsp-format").on_attach(client, bufnr)
      end
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
    if jit.os ~= "OSX" then
      vim.api.nvim_command('bel :term powershell')
    else
      vim.api.nvim_command('bel :term')
    end
  end
end

vim.keymap.set('n', '<leader>t', ToggleTerm, {})
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')
vim.keymap.set('t', '<leader><Esc>', '<C-\\><C-n><C-w>k')
