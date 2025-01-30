require('init_lazy')
require 'jj'

vim.cmd [[colorscheme onenord]]
vim.opt.background = 'light'

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
vim.opt.sessionoptions = 'buffers,curdir,folds,winsize,winpos'
vim.opt.autowriteall = true
vim.g.zig_fmt_autosave = false
vim.opt.hidden = false
vim.opt.omnifunc = 'v:lua.vim.lsp.omnifunc'
vim.o.undofile = true

vim.keymap.set({ 'i', 'n', 'v' }, '<Home>', function()
  local cursor = vim.api.nvim_win_get_cursor(0)
  vim.cmd [[normal! ^]]
  local new_cursor = vim.api.nvim_win_get_cursor(0)
  if cursor[2] == new_cursor[2] then
    vim.cmd [[normal! 0]]
  end
end)
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { silent = true })
vim.keymap.set('n', '<F12>', ':OverseerOpen bottom<CR>', { silent = true })
vim.keymap.set('n', '<leader>c', require('overseer_util').OverseerRun)
vim.keymap.set("n", "<A-;>", ':BufferPrevious<CR>', { silent = true })
vim.keymap.set("n", "<A-'>", ':BufferNext<cr>', { silent = true })
vim.keymap.set('n', '<C-c>', ':BufferClose<cr>', { silent = true })
vim.keymap.set('n', '<leader>dv', require('mini.diff').toggle_overlay)
vim.keymap.set('n', '<leader>qf', function() vim.diagnostic.setqflist() end)

local ufo = require('ufo')
vim.keymap.set('n', 'zR', ufo.openAllFolds)
vim.keymap.set('n', 'zM', ufo.closeAllFolds)

local telescope = require('telescope')
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fo', builtin.oldfiles, {});
vim.keymap.set('n', '<leader>fs', telescope.extensions.persisted.persisted, {})
vim.keymap.set('n', 'ga', vim.lsp.buf.code_action)
vim.keymap.set('n', 'gr', builtin.lsp_references)
vim.keymap.set('n', 'gt', builtin.lsp_type_definitions)
vim.keymap.set('n', 'gi', builtin.lsp_implementations)
vim.keymap.set('n', 'gd', builtin.lsp_definitions)
vim.keymap.set('n', 'gf', vim.lsp.buf.format)
vim.keymap.set('n', 'gR', vim.lsp.buf.rename)

-- Treesitter TO stuff
local ts_repeat_move = require 'nvim-treesitter.textobjects.repeatable_move'
vim.keymap.set({ "n", "x", "o" }, ';', ts_repeat_move.repeat_last_move)
vim.keymap.set({ "n", "x", "o" }, ',', ts_repeat_move.repeat_last_move_opposite)
vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })

local oil = require("oil")
vim.keymap.set('n', '<leader>e', oil.open_float)

vim.api.nvim_create_autocmd("FileType", {
  pattern = "oil",
  callback = function(event)
    vim.keymap.set('n', 'q', oil.close, { buffer = event.buf, silent = true })
  end
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function(event)
    vim.keymap.set('n', ',', '<cmd>cprevious<cr>zz<cmd>wincmd p<cr>', { buffer = event.buf, silent = true })
    vim.keymap.set('n', '.', '<cmd>cnext<cr>zz<cmd>wincmd p<cr>', { buffer = event.buf, silent = true })
  end
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "OverseerList",
  callback = function(event)
    vim.keymap.set('n', '<Esc>', function()
      local windows = vim.api.nvim_tabpage_list_wins(0)

      for _, win in ipairs(windows) do
        local buf = vim.api.nvim_win_get_buf(win)
        local is_overseer_list = vim.api.nvim_get_option_value('filetype', { buf = buf }) == 'OverseerList'
        local is_terminal = vim.api.nvim_get_option_value('buftype', { buf = buf }) == 'terminal'
        if not is_overseer_list and not is_terminal then
          vim.api.nvim_set_current_win(win)
          return
        end
      end

      vim.notify("Couldn't change window", vim.log.levels.WARN)
    end, { buffer = event.buf, silent = true })
    vim.keymap.set('n', '<F12>', '<cmd>OverseerClose<cr>', { buffer = event.buf, silent = true })
    vim.keymap.set('n', 'a', '<C-w><C-w>a', { buffer = event.buf, silent = true })
    vim.keymap.set('n', '<C-d>', '<C-w><C-w><C-d><C-w>p', { buffer = event.buf, silent = true })
    vim.keymap.set('n', '<C-u>', '<C-w><C-w><C-u><C-w>p', { buffer = event.buf, silent = true })
    vim.keymap.set('n', '<cr>', function()
      local action_util = require('overseer.action_util')
      local sidebar = require('overseer.task_list.sidebar')
      local STATUS = require('overseer.constants').STATUS
      local sb = sidebar.get_or_create()

      local task = sb:get_task_from_line()

      if not task then
        vim.notify("No task found", vim.log.levels.WARN)
        return
      end

      if task.status == STATUS.RUNNING then
        action_util.run_task_action(task, "stop")
      else
        require('overseer_util').OverseerSelectAction(task)
      end
    end, { buffer = event.buf })
    vim.keymap.set('n', '<C-Enter>', function()
      local sidebar = require('overseer.task_list.sidebar')
      local sb = sidebar.get_or_create()

      sb:run_action()
    end, { buffer = event.buf, silent = true })
    vim.keymap.set('n', '<C-c>', '<cmd>OverseerQuickAction dispose<cr>',
      { buffer = event.buf, silent = true })
  end
})

vim.api.nvim_create_autocmd("WinLeave", {
  callback = function()
    if vim.bo.ft == "TelescopePrompt" and vim.fn.mode() == "i" then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "i", true)
    end
  end
})
