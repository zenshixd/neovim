local bookmarks_list_template = [[jj bookmark list -T "self.name() ++ \"\n\""]]
local remote_bookmarks_list_template =
[[jj bookmark list -a -T "if(self.remote().starts_with('origin'), self.name() ++ \"\n\")"]]
local revisions_list_template =
[[jj log --no-graph -T "separate(' | ', self.change_id().shortest(3), self.local_bookmarks().map(|b| b.name().substr(0, 32)).join(', '), if(self.description(), self.description().first_line(), '(no description set)') ++ \"\n\")"]]

vim.api.nvim_create_user_command("JJ", function(opts)
  local status = vim.fn.system(
    [[jj st]])

  if vim.v.shell_error ~= 0 then
    vim.notify("Error getting status", vim.log.levels.ERROR)
    vim.notify(status, vim.log.levels.ERROR)
    return
  end

  vim.notify(status, vim.log.levels.INFO)
end, {});

vim.api.nvim_create_user_command("JJdescribe", function()
  local current_description = vim.split(vim.fn.system([[jj log -r @ --no-graph -T "self.description()"]]), "\n")
  local buf = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_buf_set_name(buf, "[jj describe]")
  vim.api.nvim_win_set_buf(0, buf)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, current_description)
  vim.api.nvim_set_option_value('modified', false, { buf = buf })

  vim.api.nvim_create_autocmd("BufWriteCmd", {
    buffer = buf,
    callback = function()
      local content = vim.api.nvim_buf_get_text(buf, 0, 0, -1, -1, {})
      local result = vim.fn.system([[jj describe --stdin]], content)

      if vim.v.shell_error ~= 0 then
        vim.notify("Error saving revision description", vim.log.levels.ERROR)
        vim.notify(result, vim.log.levels.ERROR)
        return
      end

      vim.api.nvim_set_option_value("modified", false, { buf = buf })
      vim.notify("Revision description saved", vim.log.levels.INFO)
      vim.notify(result, vim.log.levels.INFO)
    end
  })

  vim.api.nvim_create_autocmd("BufWinLeave", {
    buffer = buf,
    callback = function()
      vim.schedule(function()
        vim.api.nvim_buf_delete(buf, { force = true })
      end)
    end
  })
end, {})

vim.api.nvim_create_user_command("JJbl", function(opts)
  local bookmarks = vim.fn.system(bookmarks_list_template)

  if vim.v.shell_error ~= 0 then
    vim.notify("Error getting list of bookmarks", vim.log.levels.ERROR)
    vim.notify(bookmarks, vim.log.levels.ERROR)
    return
  end

  vim.ui.select(vim.split(bookmarks, "\n"), {
    prompt = "Select bookmark: ",
  }, function(branch)
    if branch ~= nil then
      vim.ui.select({ 'jj new', 'jj edit' }, {
        prompt = "Select action: ",
      }, function(action)
        if action ~= nil then
          local result = vim.fn.system(action .. " " .. branch)
          vim.notify(result, vim.log.levels.INFO)
        end
      end)
    end
  end)
end, {});

vim.api.nvim_create_user_command("JJbt", function(opts)
  local bookmarks = vim.fn.system(remote_bookmarks_list_template)

  if vim.v.shell_error ~= 0 then
    vim.notify("Error getting list of bookmarks", vim.log.levels.ERROR)
    vim.notify(bookmarks, vim.log.levels.ERROR)
    return
  end

  vim.ui.select(vim.split(bookmarks, "\n"), {
    prompt = "Select bookmark to track: ",
  }, function(branch)
    if branch ~= nil then
      local result = vim.fn.system("jj bookmark track " .. branch .. "@origin")
      vim.notify(result, vim.log.levels.INFO)
    end
  end)
end, {});

vim.api.nvim_create_user_command("JJbm", function(opts)
  local bookmarks = vim.fn.system(bookmarks_list_template)

  if vim.v.shell_error ~= 0 then
    vim.notify("Error getting list of bookmarks", vim.log.levels.ERROR)
    vim.notify(bookmarks, vim.log.levels.ERROR)
    return
  end

  vim.ui.select(vim.split(bookmarks, "\n"), {
    prompt = "Select bookmark to move: ",
  }, function(branch)
    if branch ~= nil then
      local result = vim.fn.system("jj bookmark move " .. branch)
      vim.notify(result, vim.log.levels.INFO)
    end
  end)
end, {});

vim.api.nvim_create_user_command("JJnew", function(opts)
  local revisions = vim.fn.system(revisions_list_template);

  if vim.v.shell_error ~= 0 then
    vim.notify("Error getting list of revisions", vim.log.levels.ERROR)
    vim.notify(revisions, vim.log.levels.ERROR)
    return
  end

  vim.ui.select(vim.split(revisions, "\n"), {
    prompt = "Select parent revision: ",
  }, function(revision)
    if revision ~= nil then
      local changeId = vim.split(revision, " | ")[1]
      local result = vim.fn.system("jj new " .. changeId)
      vim.notify(result, vim.log.levels.INFO)
    end
  end)
end, {});

vim.api.nvim_create_user_command("JJedit", function(opts)
  local revisions = vim.fn.system(revisions_list_template)

  if vim.v.shell_error ~= 0 then
    vim.notify("Error getting list of revisions", vim.log.levels.ERROR)
    vim.notify(revisions, vim.log.levels.ERROR)
    return
  end

  vim.ui.select(vim.split(revisions, "\n"), {
    prompt = "Select revision to edit: ",
  }, function(revision)
    if revision ~= nil then
      local changeId = vim.split(revision, " | ")[1]
      local result = vim.fn.system("jj edit " .. changeId)
      vim.notify(result, vim.log.levels.INFO)
    end
  end)
end, {});

vim.api.nvim_create_user_command("JJdiff", function(opts)
  local diff = vim.fn.system([[jj diff --no-pager --git]])
  local buf = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_buf_set_name(buf, "[jj diff]")
  vim.api.nvim_win_set_buf(0, buf)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(diff, "\n"))
  vim.api.nvim_set_option_value('filetype', "diff", { buf = buf })
  vim.api.nvim_create_autocmd("BufWinLeave", {
    buffer = buf,
    callback = function()
      vim.schedule(function()
        vim.api.nvim_buf_delete(buf, { force = true })
      end)
    end
  })
end, {})
