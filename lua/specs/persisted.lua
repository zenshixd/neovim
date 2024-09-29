return {
  "olimorris/persisted.nvim",
  lazy = false,
  config = function()
    local persisted = require('persisted')
    local overseer = require('overseer')
    persisted.setup({
      autostart = true,
      autoload = true,
      use_git_branch = true,
      on_autoload_no_session = function()
        vim.notify("No existing session to load.")
      end
    })
    persisted.branch = function()
      if vim.loop.fs_stat(".jj") then
        local branch = vim.fn.system("jj bookmark list -r @ -r @- -T 'self.name()'")
        return vim.v.shell_error == 0 and branch or nil
      end
      if vim.loop.fs_stat(".git") then
        local branch = vim.fn.systemlist("git branch --show-current")[1]
        return vim.v.shell_error == 0 and branch or nil
      end
    end

    local function get_cwd_as_name()
      local dir = vim.fn.getcwd(0)
      return dir:gsub("[^A-Za-z0-9]", "_")
    end
    vim.api.nvim_create_autocmd("User", {
      pattern = "PersistedLoadPost",
      callback = function()
        local bufs = vim.api.nvim_list_bufs()
        for _, buf in ipairs(bufs) do
          if vim.api.nvim_buf_get_name(buf):match("^oil") ~= nil then
            vim.api.nvim_buf_delete(buf, { force = true })
          end
        end
        overseer.load_task_bundle(get_cwd_as_name(), { ignore_missing = true, autostart = false })
      end
    })
    vim.api.nvim_create_autocmd("User", {
      pattern = "PersistedSavePre",
      callback = function()
        overseer.save_task_bundle(get_cwd_as_name(), nil, { on_conflict = "overwrite" })
      end
    })
  end,
}
