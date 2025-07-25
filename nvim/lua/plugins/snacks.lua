-- Show ignored files (dotfiles)

local excluded = {
  "node_modules/",
  "dist/",
  ".vite/",
  ".git/",

  "package-lock.json",
  "pnpm-lock.yaml",
  "yarn.lock",
}

return {
  "folke/snacks.nvim",
  opts = {
    notifier = { enabled = true },

    -- show hidden files in snacks.explorer
    picker = {
      sources = {
        explorer = {
          -- show hidden files like .env
          hidden = true,
          -- show files ignored by git like node_modules
          ignored = true,
          -- exlude some file
          exclude = excluded,
        },
      },
    },
  },
}
