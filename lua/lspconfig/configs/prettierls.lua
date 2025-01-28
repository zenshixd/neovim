return {
  default_config = {
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
    root_dir = function(fname)
      return vim.fs.root(fname, "package.json") and vim.fs.root(fname, "node_modules/prettier")
    end,
    single_file_support = true,
    settings = {},
  }
}
