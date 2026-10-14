return {
  -- Re-enable treesitter with proper configuration
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "diff",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "printf",
        "python",
        "query",
        "regex",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
      },
    },
  },
  
  -- Re-enable Mason for LSP management
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "pyright",
        "stylua",
        "shellcheck",
        "shfmt",
      },
    },
  },
}
