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

require("lazy").setup({
  spec = {
    { "nvimtools/none-ls.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
    { "nvimtools/none-ls-extras.nvim", dependencies = { "nvimtools/none-ls.nvim" } },
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
      cond = function() return vim.fn.getcwd():find('wkapp%-taskflow') == nil end,
    },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    { "lukas-reineke/lsp-format.nvim" },
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
        local telescope = require('telescope')
        telescope.load_extension('persisted')
        vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
        vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
        vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
        vim.keymap.set('n', '<leader>fs', telescope.extensions.persisted.persisted, {})
      end
    },
    {
      "kevinhwang91/nvim-ufo",
      dependencies = {
        "kevinhwang91/promise-async",
      },
      config = function()
        require("ufo").setup({
          provider_selector = function(bufnr, filetype, filename)
            return {'treesitter', 'indent'}
          end,
        })
        vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
        vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
      end
    },
    {
      "olimorris/persisted.nvim",
      config = function(_, opts)
        require("persisted").branch = function()
          return vim.fn.system("jj branch list -r @ -r @- -T 'self.name()'")
        end
        require("persisted").setup(opts)
      end,
      lazy = false,
    },
    {
      'romgrk/barbar.nvim',
      dependencies = {
        'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
        'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
      },
      init = function() vim.g.barbar_auto_setup = false end,
      opts = {},
      version = '^1.0.0', -- optional: only update when a new 1.x version is released
    },
    {
      'stevearc/overseer.nvim',
      opts = {},
    }
  },
  defaults = {
    version = "*",
  },
  install = { colorscheme = { "habamax" } },
  checker = { enabled = true, notify = false },
})
