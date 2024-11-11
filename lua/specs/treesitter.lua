return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    version = false,
    event = "VeryLazy",
    config = function()
      require 'nvim-treesitter.configs'.setup {
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "zig", "typescript", "javascript", "json", "json5", "diff" },
        sync_install = false,
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = false,
        }
      }
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = "VeryLazy",
    config = function()
      require("nvim-treesitter.configs").setup {
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              ["ab"] = "@block.outer",
              ["ib"] = "@block.inner",
              ["av"] = "@assignment.outer",
              ["iv"] = "@assignment.inner",
              ["al"] = "@assignment.lhs",
              ["ar"] = "@assignment.rhs",
              ["as"] = "@statement.outer"
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]f"] = "@function.outer",
              ["]c"] = "@class.outer",
              ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
              ["]b"] = "@block.outer",
              ["]s"] = "@statement.outer",
              ["]h"] = "@diff.hunk",
            },
            goto_next_end = {
              ["]F"] = "@function.outer",
              ["]C"] = "@class.outer",
              ["]Z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
              ["]B"] = "@block.outer",
              ["]S"] = "@statement.outer",
              ["]H"] = "@diff.hunk",
            },
            goto_previous_start = {
              ["[f"] = "@function.outer",
              ["[c"] = "@class.outer",
              ["[z"] = { query = "@fold", query_group = "folds", desc = "Previous fold" },
              ["[b"] = "@block.outer",
              ["[s"] = "@statement.outer",
              ["[h"] = "@diff.hunk",
            },
            goto_previous_end = {
              ["[F"] = "@function.outer",
              ["[C"] = "@class.outer",
              ["[Z"] = { query = "@fold", query_group = "folds", desc = "Previous fold" },
              ["[B"] = "@block.outer",
              ["[S"] = "@statement.outer",
              ["[H"] = "@diff.hunk",
            },
          },
        },
      }
    end,
  }
}
