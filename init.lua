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

vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')
vim.keymap.set('n', '<F12>', ':OverseerToggle bottom<CR>')
vim.keymap.set('n', '<leader>qq', ':qa<CR>')
vim.keymap.set('n', '<leader>ca', ':OverseerTaskAction<cr>')
vim.keymap.set('n', '<leader>cc', ':OverseerRun<cr>')
vim.keymap.set("n", "<C-,>", ':BufferPrevious<CR>')
vim.keymap.set("n", "<C-.>", ':BufferNext<cr>')
vim.keymap.set('n', '<C-c>', ':BufferClose<cr>')
vim.keymap.set('n', '<leader>dv', ":DiffviewOpen<cr>")

local ufo = require('ufo')
vim.keymap.set('n', 'zR', ufo.openAllFolds)
vim.keymap.set('n', 'zM', ufo.closeAllFolds)

local telescope = require('telescope')
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fs', telescope.extensions.persisted.persisted, {})
vim.keymap.set('n', 'ga', vim.lsp.buf.code_action)
vim.keymap.set('n', 'gr', builtin.lsp_references)
vim.keymap.set('n', 'gt', builtin.lsp_type_definitions)
vim.keymap.set('n', 'gd', builtin.lsp_definitions)
vim.keymap.set('n', 'gf', vim.lsp.buf.format)
vim.keymap.set('n', 'gR', vim.lsp.buf.rename)
