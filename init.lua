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
vim.keymap.set("n", "<A-,>", ':BufferPrevious<CR>')
vim.keymap.set("n", "<A-.>", ':BufferNext<cr>')
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
vim.keymap.set('n', '<leader>fo', builtin.oldfiles, {});
vim.keymap.set('n', '<leader>fs', telescope.extensions.persisted.persisted, {})
vim.keymap.set('n', 'K', '<cmd>Lspsaga hover_doc<cr>')
vim.keymap.set('n', 'ga', '<cmd>Lspsaga code_action<cr>')
vim.keymap.set('n', 'gr', '<cmd>Lspsaga finder ref<cr>')
vim.keymap.set('n', 'gt', '<cmd>Lspsaga peek_type_definition<cr>')
vim.keymap.set('n', 'gi', '<cmd>Lspsaga finder imp<cr>')
vim.keymap.set('n', 'gd', '<cmd>Lspsaga peek_definition<cr>')
vim.keymap.set('n', 'gf', vim.lsp.buf.format)
vim.keymap.set('n', 'gR', '<cmd>Lspsaga rename<cr>')
