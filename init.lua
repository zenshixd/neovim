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
vim.opt.sessionoptions = 'buffers,curdir,folds,tabpages,winsize,winpos'
vim.g.zig_fmt_autosave = false


vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')
vim.keymap.set('n', '<F12>', ':OverseerToggle bottom<CR>')
vim.keymap.set('n', '<leader>qq', ':qa<CR>')
vim.keymap.set('n', '<leader>ca', ':OverseerTaskAction<cr>')
vim.keymap.set('n', '<leader>cc', ':OverseerRun<cr>')
vim.keymap.set("n", "<C-,>", ':BufferPrevious<CR>')
vim.keymap.set("n", "<C-.>", ':BufferNext<cr>')
vim.keymap.set('n', '<C-q>', ':BufferClose<cr>')
vim.keymap.set('n', '<leader>ga', vim.lsp.buf.code_action)
vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references)
vim.keymap.set('n', '<leader>gt', vim.lsp.buf.type_definition)
vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition)
vim.keymap.set('n', '<leader>gf', vim.lsp.buf.format)
vim.keymap.set('n', '<leader>gR', vim.lsp.buf.rename)

local LspGroup = vim.api.nvim_create_augroup("LspGroup", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
    vim.api.nvim_clear_autocmds({
      event = {'CursorHold', 'CursorHoldI', 'CursorMoved'},
      group = LspGroup
    })
--    vim.api.nvim_create_autocmd({'CursorHold', 'CursorHoldI'}, {
--      group = LspGroup,
--      callback = vim.lsp.buf.document_highlight,
--    })
    vim.api.nvim_create_autocmd({'CursorMoved'}, {
      group = LspGroup,
      callback = function()
        vim.lsp.buf.clear_references()
        vim.lsp.buf.document_highlight()
      end,
    })
	end,
})
