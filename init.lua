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

function TermNext()
  local bufs = vim.api.nvim_list_bufs()
  local term_bufs = vim.tbl_filter(function(buf)
    local buf_title = vim.api.nvim_buf_get_name(buf)
    return buf_title:match("^term://") ~= nil
  end, bufs)
  local current_buf = vim.api.nvim_get_current_buf()
  local cur_buf_index = vim.fn.index(term_bufs, current_buf) + 1
  if cur_buf_index + 1 > #term_bufs then
    vim.api.nvim_set_current_buf(term_bufs[1])
  else
    vim.api.nvim_set_current_buf(term_bufs[cur_buf_index + 1])
  end
end

function BufferNext()
  local bufs = vim.api.nvim_list_bufs()
  local current_buf = vim.api.nvim_get_current_buf()
  local buf_title = vim.api.nvim_buf_get_name(current_buf)
  if buf_title:match("^term://") ~= nil then
    TermNext()
  else
    vim.api.nvim_command('BufferNext')
  end
end

function TermPrev()
  local bufs = vim.api.nvim_list_bufs()
  local term_bufs = vim.tbl_filter(function(buf)
    local buf_title = vim.api.nvim_buf_get_name(buf)
    return buf_title:match("^term://") ~= nil
  end, bufs)
  local current_buf = vim.api.nvim_get_current_buf()
  local cur_buf_index = vim.fn.index(term_bufs, current_buf) + 1
  if cur_buf_index - 1 < 1 then
    vim.api.nvim_set_current_buf(term_bufs[#term_bufs])
  else
    vim.api.nvim_set_current_buf(term_bufs[cur_buf_index - 1])
  end
end

function BufferPrev()
  local bufs = vim.api.nvim_list_bufs()
  local current_buf = vim.api.nvim_get_current_buf()
  local buf_title = vim.api.nvim_buf_get_name(current_buf)
  if buf_title:match("^term://") ~= nil then
    TermPrev()
  else
    vim.api.nvim_command('BufferPrevious')
  end
end

function BufferClose()
  local current_buf = vim.api.nvim_get_current_buf()
  local buf_title = vim.api.nvim_buf_get_name(current_buf)
  if buf_title:match("^term://") ~= nil then
    TermNext()
    vim.api.nvim_command(current_buf .. 'bd!')
  else
    vim.api.nvim_command('BufferClose')
  end
end

vim.keymap.set('n', '<leader>t', ToggleTerm, {})
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')
vim.keymap.set('t', '<leader><Esc>', '<C-\\><C-n><C-w>k')
vim.keymap.set('n', '<leader>qq', ':qa<CR>')
vim.keymap.set("n", "<C-,>", BufferPrev, {})
vim.keymap.set("n", "<C-.>", BufferNext, {})
vim.keymap.set('n', '<C-q>', BufferClose, {})
