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

vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { silent = true })
vim.keymap.set('n', '<F12>', ':OverseerOpen bottom<CR>', { silent = true })
vim.keymap.set('n', '<leader>ca', ':OverseerTaskAction<cr>', { silent = true })
vim.keymap.set('n', '<leader>cc', ':OverseerRun<cr>', { silent = true })
vim.keymap.set("n", "<A-,>", ':BufferPrevious<CR>', { silent = true })
vim.keymap.set("n", "<A-.>", ':BufferNext<cr>', { silent = true })
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
  pattern = "qf",
  callback = function(event)
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
vim.api.nvim_create_user_command("Enext", function(opts)
  local fullname = vim.fn.expand("%")
  local dir = vim.fs.dirname(fullname)
  local scanner = vim.uv.fs_scandir(dir)
  local name = vim.fs.basename(fullname)

  local next_entry = nil
  local pick_next = false
  while true do
    local entry = vim.uv.fs_scandir_next(scanner)
    if entry == nil then
      break
    end

    if pick_next then
      next_entry = entry;
      break
    end

    if entry == name then
      pick_next = true
    end
  end

  if next_entry ~= nil then
    vim.cmd("e " .. next_entry)
  end
end, {})
