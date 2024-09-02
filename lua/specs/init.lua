return {
  {
    "ellisonleao/gruvbox.nvim",
    config = function()
      require('gruvbox').setup{
        contrast = 'hard',
      }
      vim.o.background = 'light'
      vim.cmd [[colorscheme gruvbox]]
    end
  },
  {
    "pocco81/auto-save.nvim",
    opts = {
      trigger_events = { "InsertLeave" },
      condition = function() return vim.bo.filetype ~= "OverseerForm" end
    }
  },
  {
    "supermaven-inc/supermaven-nvim",
    init = function()
      require("supermaven-nvim").setup({})
    end,
    cond = function() return vim.fn.getcwd():find('wkapp%-taskflow') == nil end,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true
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
    config = function()
      local overseer = require('overseer')
      overseer.setup{}
      overseer.add_template_hook({ module = ".*" }, function(task_defn, util)
        util.add_component(task_defn, { "unique" })
        util.remove_component(task_defn, "on_complete_dispose")
      end)
    end,
  }
}
