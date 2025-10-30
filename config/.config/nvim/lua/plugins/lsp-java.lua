return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        jdtls = {
          root_dir = function(fname)
            local util = require("lspconfig.util")
            return util.root_pattern("build.xml", ".git")(fname) or vim.fs.dirname(fname)
          end,
        },
      },
    },
  },
}
