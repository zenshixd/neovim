return {
  "stevearc/oil.nvim",
  config = function()
    require('oil').setup()

    vim.api.nvim_create_autocmd("User", {
      pattern = "OilActionsPost",
      callback = function(event)
        local Snacks = require('snacks')
        if event.data.actions.type == "move" then
          Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
        end
      end
    })
  end,
}
