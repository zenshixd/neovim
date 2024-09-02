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
      return vim.fn.system("jj branch list -r @ -r @- -T 'self.name()'")
    end

		local function get_cwd_as_name()
		  local dir = vim.fn.getcwd(0)
		  return dir:gsub("[^A-Za-z0-9]", "_")
		end
		vim.api.nvim_create_autocmd("User", {
		  pattern = "PersistedLoadPost",
		  callback = function()
		    overseer.load_task_bundle(get_cwd_as_name(), {ignore_missing = true, autostart = false})
		  end
		})
		vim.api.nvim_create_autocmd("User", {
		  pattern = "PersistedSavePre",
		  callback = function()
		    overseer.save_task_bundle(get_cwd_as_name(), nil, {on_conflict = "overwrite"})
		  end
		})
	end,
}
