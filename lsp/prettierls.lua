return {
  cmd = { "prettierls", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "vue",
    "css",
    "scss",
    "less",
    "html",
    "json",
    "jsonc",
    "yaml",
    "markdown",
    "markdown.mdx",
    "graphql",
    "handlebars",
    "svelte",
    "astro",
    "htmlangular",
  },
  root_markers = { ".git", ".jj", "node_modules/prettier" },
  -- root_dir = function(fname)
  --   local root_dir = vim.fs.root(fname, "package.json") and vim.fs.root(fname, "node_modules/prettier")
  --
  --   if root_dir ~= nil then
  --     return vim.fs.dirname(root_dir)
  --   end
  --
  --   return nil
  -- end,
  single_file_support = true,
  settings = {},
}
