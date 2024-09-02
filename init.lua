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
vim.opt.sessionoptions = 'buffers,curdir,folds,tabpages,winsize,winpos,terminal'
vim.g.zig_fmt_autosave = false

vim.cmd [[colorscheme dracula]]

vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')
vim.keymap.set('n', '<F12>', ':OverseerToggle bottom<CR>')
vim.keymap.set('n', '<leader>qq', ':qa<CR>')
vim.keymap.set('n', '<leader>ca', ':OverseerTaskAction<cr>')
vim.keymap.set('n', '<leader>cc', ':OverseerRun<cr>')
vim.keymap.set('n', '<leader>cs', ':OverseerRunCmd<cr>')
vim.keymap.set("n", "<C-,>", ':BufferPrevious<CR>')
vim.keymap.set("n", "<C-.>", ':BufferNext<cr>')
vim.keymap.set('n', '<C-q>', ':BufferClose<cr>')
