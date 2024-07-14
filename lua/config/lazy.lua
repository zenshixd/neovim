-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
--vim.g.mapleader = " "
--vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
    },
    { "Mofiqul/dracula.nvim" },
    {
      "pocco81/auto-save.nvim",
      opts = {
        trigger_events = { "InsertLeave" },
      }
    },
    {
      "supermaven-inc/supermaven-nvim",
      init = function()
        require("supermaven-nvim").setup({})
      end,
    },
    {
      "neovim/nvim-lspconfig",
      lazy = false,
      dependencies = {
        { "ms-jpq/coq_nvim",       branch = "coq" },
        { "ms-jpq/coq.artifacts",  branch = "artifacts" },
        { "ms-jpq/coq.thirdparty", branch = "3p" },
      },
      init = function()
        vim.g.coq_settings = {
          auto_start = true,
          keymap = {
            recommended = false,
          },
          ["clients.tree_sitter.enabled"] = false,
          ["clients.buffers.enabled"] = false,
        }
        vim.api.nvim_set_keymap('i', '<Esc>', [[pumvisible() ? "\<C-e>" : "\<Esc>"]], { expr = true, silent = true })
        vim.api.nvim_set_keymap('i', '<C-c>', [[pumvisible() ? "\<C-e><C-c>" : "\<C-c>"]], { expr = true, silent = true })
        vim.api.nvim_set_keymap('i', '<BS>', [[pumvisible() ? "\<C-e><BS>" : "\<BS>"]], { expr = true, silent = true })
        vim.api.nvim_set_keymap(
          "i",
          "<CR>",
          [[pumvisible() ? (complete_info().selected == -1 ? "\<C-e><CR>" : "\<C-y>") : "\<CR>"]],
          { expr = true, silent = true }
        )
        require("coq_3p") {
          { src = "nvimlua", short_name = "nLUA" },
        }
      end,
    },
    { 'kosayoda/nvim-lightbulb' },
    { "lukas-reineke/lsp-format.nvim" },
    {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      config = function()
        require("nvim-autopairs").setup {}
      end
    },
    {
      "nvim-telescope/telescope.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
      },
      init = function()
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
        vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
        vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
      end
    }
  },
  defaults = {
    version = "*",
  },
  install = { colorscheme = { "habamax" } },
  checker = { enabled = true, notify = false },
})
