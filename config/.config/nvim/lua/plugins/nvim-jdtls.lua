return {
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    config = function()
      local jdtls = require("jdtls")

      local home = os.getenv("HOME")
      local root_markers = { "build.xml", "pom.xml", "settings.gradle", ".git" }
      local root_dir = require("jdtls.setup").find_root(root_markers)

      if not root_dir then
        return
      end

      local workspace_dir = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

      jdtls.start_or_attach({
        cmd = { "jdtls" },
        root_dir = root_dir,
        workspace_folder = workspace_dir,
        settings = {
          java = {},
        },
      })
    end,
  },
}
