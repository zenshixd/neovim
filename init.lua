require('init_lazy')
require 'jj'
local Snacks = require('snacks')

vim.cmd [[colorscheme onenord]]
vim.opt.background = 'light'

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.foldmethod = "expr"
vim.opt.foldtext = "getline(v:foldstart)"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldcolumn = '1'
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.sessionoptions = 'buffers,curdir,folds,winsize,winpos'
vim.opt.autowriteall = true
vim.g.zig_fmt_autosave = false
vim.opt.hidden = false
vim.opt.omnifunc = 'v:lua.vim.lsp.omnifunc'
vim.o.undofile = true
vim.diagnostic.config({ virtual_text = true })
-- vim.opt.completeopt = 'menuone,noinsert'

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  callback = function()
    vim.cmd [[checktime]]
  end
})

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
vim.keymap.set("n", "<A-;>", ':BufferLineCyclePrev<CR>', { silent = true })
vim.keymap.set("n", "<A-'>", ':BufferLineCycleNext<cr>', { silent = true })
vim.keymap.set('n', '<C-c>', function()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.cmd("BufferLineCyclePrev")
  vim.cmd("bd! " .. bufnr)
end, { silent = true })
vim.keymap.set('n', '<leader>dv', require('mini.diff').toggle_overlay)
vim.keymap.set('n', '<leader>qf', function() vim.diagnostic.setqflist() end)
vim.keymap.set({ 'i', 'n', 'x' }, '<S-Up>', '<Up>')
vim.keymap.set({ 'i', 'n', 'x' }, '<S-Down>', '<Down>')
vim.keymap.set({ 'n', 'i', 's' }, '<C-Left>', function()
  if vim.snippet.active({ direction = -1 }) then
    return '<Cmd>lua vim.snippet.jump(-1)<CR>'
  end
end, { expr = true, silent = true })
vim.keymap.set({ 'n', 'i', 's' }, '<C-Right>', function()
  if vim.snippet.active({ direction = 1 }) then
    return '<Cmd>lua vim.snippet.jump(1)<CR>'
  end
end, { expr = true, silent = true })

vim.keymap.set('n', '<leader>ff', Snacks.picker.files, {})
vim.keymap.set('n', '<leader>fg', Snacks.picker.grep, {})
vim.keymap.set('n', '<leader>fG', function()
  vim.ui.input({
    default = vim.fn.expand("%:h"),
    prompt = 'Directory to search'
  }, function(dir)
    Snacks.picker.grep({ dirs = { dir } })
  end)
end, {})
vim.keymap.set('n', '<leader>fd', Snacks.picker.diagnostics, {})
vim.keymap.set('n', '<leader>;', Snacks.picker.buffers, {})
vim.keymap.set('n', 'gb', Snacks.picker.buffers, {})
vim.keymap.set('n', '<leader>fh', Snacks.picker.help, {})
vim.keymap.set('n', '<leader>fr', Snacks.picker.recent, {})

-- DAP
vim.keymap.set('n', '<leader>db', ":DapToggleBreakpoint<cr>", { silent = true })
vim.keymap.set('n', '<leader>dc', ":DapContinue<cr>", { silent = true })
vim.keymap.set('n', '<leader>di', ":DapStepInto<cr>", { silent = true })
vim.keymap.set('n', '<leader>do', ":DapStepOver<cr>", { silent = true })
vim.keymap.set('n', '<leader>du', ":DapStepOut<cr>", { silent = true })
vim.keymap.set('n', '<leader>dR', ":DapToggleRepl<cr>", { silent = true })
vim.keymap.set('n', '<leader>dT', ":DapTerminate<cr>", { silent = true })
vim.keymap.set('n', '<leader>dE', ":DapEval<cr>", { silent = true })
vim.keymap.set({ 'n', 'v' }, '<Leader>dh', function()
  require('dap.ui.widgets').hover()
end)
vim.keymap.set({ 'n', 'v' }, '<Leader>dp', function()
  require('dap.ui.widgets').preview()
end)
vim.keymap.set('n', '<Leader>df', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.frames)
end)
vim.keymap.set('n', '<Leader>ds', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.scopes)
end)

-- Treesitter TO stuff
local ts_repeat_move = require 'nvim-treesitter.textobjects.repeatable_move'
vim.keymap.set({ "n", "x", "o" }, ';', ts_repeat_move.repeat_last_move)
vim.keymap.set({ "n", "x", "o" }, ',', ts_repeat_move.repeat_last_move_opposite)
vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })

local oil = require("oil")
vim.keymap.set('n', '<leader>e', oil.open)

vim.api.nvim_create_autocmd("FileType", {
  pattern = "oil",
  callback = function(event)
    vim.keymap.set('n', 'q', oil.close, { buffer = event.buf, silent = true })
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

vim.api.nvim_create_user_command("Ref", function(opts)
  local buf_name = vim.api.nvim_buf_get_name(0)
  local name = vim.fs.basename(buf_name)
  name = name:gsub("%.ts", "$1.js")

  vim.cmd("edit .reftests/baselines/reference/" .. name)
end, {})


vim.api.nvim_create_user_command("Local", function(opts)
  local buf_name = vim.api.nvim_buf_get_name(0)
  local name = vim.fs.basename(buf_name)
  name = name:gsub("%.ts", "$1.js")

  vim.cmd("edit .reftests/baselines/local/" .. name)
end, {})
