require('init_lazy')

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
vim.g.zig_fmt_autosave = false
vim.o.hidden = false
vim.o.omnifunc = 'v:lua.vim.lsp.omnifunc'

vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { silent = true })
vim.keymap.set('n', '<F12>', ':OverseerOpen right<CR>', { silent = true })
vim.keymap.set('n', '<leader>qq', ':qa<CR>', { silent = true })
vim.keymap.set('n', '<leader>ca', ':OverseerTaskAction<cr>', { silent = true })
vim.keymap.set('n', '<leader>cc', ':OverseerRun<cr>', { silent = true })
vim.keymap.set("n", "<A-,>", ':BufferPrevious<CR>', { silent = true })
vim.keymap.set("n", "<A-.>", ':BufferNext<cr>', { silent = true })
vim.keymap.set('n', '<C-c>', ':BufferClose<cr>', { silent = true })
vim.keymap.set('n', '<leader>dv', require('mini.diff').toggle_overlay)

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
vim.keymap.set('n', 'K', '<cmd>Lspsaga hover_doc<cr>', { silent = true })
vim.keymap.set('n', 'ga', vim.lsp.buf.code_action)
vim.keymap.set('n', 'gr', builtin.lsp_references)
vim.keymap.set('n', 'gt', '<cmd>Lspsaga peek_type_definition<cr>', { silent = true })
vim.keymap.set('n', 'gi', '<cmd>Lspsaga finder imp<cr>', { silent = true })
vim.keymap.set('n', 'gd', '<cmd>Lspsaga peek_definition<cr>', { silent = true })
vim.keymap.set('n', 'gf', vim.lsp.buf.format)
vim.keymap.set('n', 'gR', vim.lsp.buf.rename)

local oil = require("oil")
vim.keymap.set('n', '<leader>e', oil.open_float)

vim.api.nvim_create_autocmd("FileType", {
  pattern = "oil",
  callback = function(event)
    vim.print('oil autocmd: ' .. event.buf)
    vim.keymap.set('n', 'q', oil.close, { buffer = event.buf, silent = true })
  end
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function(event)
    vim.keymap.set('n', 'q', function() vim.cmd("cclose") end, { buffer = event.buf, silent = true })
    vim.keymap.set('n', ',', '<cmd>cprevious<cr>zz<cmd>wincmd p<cr>', { buffer = event.buf, silent = true })
    vim.keymap.set('n', '.', '<cmd>cnext<cr>zz<cmd>wincmd p<cr>', { buffer = event.buf, silent = true })
  end
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "OverseerList",
  callback = function(event)
    vim.keymap.set('n', '<Esc>', '<C-w><C-w>', { buffer = event.buf, silent = true })
    vim.keymap.set('n', '<F12>', '<cmd>OverseerClose<cr>', { buffer = event.buf, silent = true })
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

      if task.status == STATUS.PENDING then
        action_util.run_task_action(task, "start")
      elseif task.status == STATUS.RUNNING then
        action_util.run_task_action(task, "stop")
      else
        action_util.run_task_action(task, "restart")
      end
    end, { buffer = event.buf })
    vim.keymap.set('n', '<C-Enter>', function()
      local sidebar = require('overseer.task_list.sidebar')
      local sb = sidebar.get_or_create()

      sb:run_action()
    end, { buffer = event.buf, silent = true })
    vim.keymap.set('n', '<C-c>', '<cmd>OverseerQuickAction dispose<cr>', { buffer = event.buf, silent = true })
  end
})
