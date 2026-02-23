-- ═══════════════════════════════════════════════════════════
-- PLUGINS - snacks.nvim (Explorer & Notifier Configuration)
-- ═══════════════════════════════════════════════════════════
--
-- Show ignored files (dotfiles)
-- Configures snacks.nvim to display hidden and git-ignored files
-- in the file explorer, while excluding noisy build artifacts and lockfiles.

-- ─── Excluded Paths ────────────────────────────────────────
-- Files and directories listed here will never appear in the explorer,
-- even when hidden and ignored visibility are both enabled.
-- This keeps the tree clean by hiding irrelevant generated files.
local excluded = {
  ".git/", -- Git internals directory
  "dist/", -- Build output directory
  ".vite/", -- Vite cache directory
  "node_modules/", -- NPM dependency tree (usually very large)
  "bun.lock", -- Bun lockfile
  "yarn.lock", -- Yarn lockfile
  "pnpm-lock.yaml", -- PNPM lockfile
  "package-lock.json", -- NPM lockfile
}

return {
  "folke/snacks.nvim",
  opts = {
    -- ─── Notifier ──────────────────────────────────────────────
    -- Enables the snacks notification system, which provides styled
    -- popup notifications as an alternative to nvim-notify.
    notifier = { enabled = true },

    -- ─── Picker / Explorer ─────────────────────────────────────
    -- Configures the snacks picker sources, specifically the built-in
    -- file explorer to control which files are visible.
    picker = {
      sources = {
        explorer = {
          -- Show dotfiles and other hidden files (e.g. .env, .gitignore)
          -- that are normally invisible in file explorers.
          hidden = true,

          -- Show files that are ignored by git (e.g. node_modules, dist)
          -- so they can be accessed when needed without leaving Neovim.
          ignored = true,

          -- Apply the exclusion list defined above to filter out
          -- files and directories that add noise without value.
          exclude = excluded,
        },
      },
    },
  },
}
