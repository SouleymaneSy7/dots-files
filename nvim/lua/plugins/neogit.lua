-- ═══════════════════════════════════════════════════════════
-- PLUGINS - neogit (Magit-style Git Interface)
-- ═══════════════════════════════════════════════════════════
--
-- A Magit-inspired interface for git: staging hunks, committing,
-- branching, rebasing, and browsing the log — all from inside Neovim.
-- Integrates with diffview.nvim for rich diff rendering and with
-- Telescope for branch / ref selection popups.
--
-- Key commands:
--   <leader>gn   → open neogit status (main panel)
--   <leader>gnc  → commit popup
--   <leader>gnp  → push popup
--   <leader>gnP  → pull popup
--   <leader>gnb  → branch popup
--   <leader>gnl  → log popup

return {
  "NeogitOrg/neogit",

  -- Load on the :Neogit command only; git context initialisation is slow.
  cmd = "Neogit",

  dependencies = {
    "nvim-lua/plenary.nvim", -- Async I/O and path utilities
    "sindrets/diffview.nvim", -- Renders diffs inside neogit panels
    "nvim-telescope/telescope.nvim", -- Powers branch / ref picker popups
  },

  keys = {
    { "<leader>gn", "<cmd>Neogit<cr>", desc = "Neogit status" },
    { "<leader>gnc", "<cmd>Neogit commit<cr>", desc = "Commit" },
    { "<leader>gnp", "<cmd>Neogit push<cr>", desc = "Push" },
    { "<leader>gnP", "<cmd>Neogit pull<cr>", desc = "Pull" },
    { "<leader>gnb", "<cmd>Neogit branch<cr>", desc = "Branch" },
    { "<leader>gnl", "<cmd>Neogit log<cr>", desc = "Log" },
  },

  opts = {
    -- ─── Integrations ──────────────────────────────────────────
    integrations = {
      diffview = true, -- Use diffview.nvim for inline diff display
      telescope = true, -- Use telescope for branch / ref pickers
    },

    -- ─── Graph Style ───────────────────────────────────────────
    -- 'unicode' renders the commit graph with box-drawing characters.
    -- Other options: 'ascii' | 'kitty' (requires kitty terminal)
    graph_style = "unicode",

    -- ─── Confirmation ──────────────────────────────────────────
    -- Prompt before discarding uncommitted changes.
    -- Set to true for extra safety if you often misfire the discard key.
    disable_commit_confirmation = false,

    -- ─── Auto Refresh ──────────────────────────────────────────
    -- Automatically refresh the status window after external git operations
    -- (e.g. running git pull in a terminal split).
    auto_refresh = true,

    -- ─── Section Signs ─────────────────────────────────────────
    -- Collapse / expand indicators for each section type in the status panel.
    -- First value = collapsed icon, second = expanded icon.
    signs = {
      hunk = { "", "" },
      item = { "", "" },
      section = { "", "" },
    },
  },
}
