-- ═══════════════════════════════════════════════════════════
-- PLUGINS - diffview.nvim (Git Diff & History Viewer)
-- ═══════════════════════════════════════════════════════════
--
-- Multi-panel diff viewer and file history browser built on git.
-- Opens a full-screen tabpage with a sidebar of changed files and
-- side-by-side diffs. Also integrates with neogit for merge conflicts.
--
-- Key commands:
--   <leader>gd  → open diff vs HEAD
--   <leader>gD  → close diffview
--   <leader>gv  → file history for the current file
--   <leader>gV  → full repository history

return {
  "sindrets/diffview.nvim",

  -- Load on command only; diffview is heavyweight and unneeded at startup.
  cmd = {
    "DiffviewOpen",
    "DiffviewClose",
    "DiffviewToggleFiles",
    "DiffviewFocusFiles",
    "DiffviewFileHistory",
    "DiffviewRefresh",
  },

  keys = {
    { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diff vs HEAD" },
    { "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Close diffview" },
    { "<leader>gv", "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
    { "<leader>gV", "<cmd>DiffviewFileHistory<cr>", desc = "Repo history" },
  },

  opts = {
    -- ─── Appearance ────────────────────────────────────────────
    -- Uses extra highlight groups to visually distinguish modified
    -- words within a changed line (not just the whole line).
    enhanced_diff_hl = true,

    -- Show a hint footer inside each diff view with available keymaps.
    show_help_hints = true,

    -- ─── View Layouts ──────────────────────────────────────────
    view = {
      -- Standard diff: two panes side-by-side (old on the left, new on the right).
      default = {
        layout = "diff2_horizontal",
        winbar_info = true, -- Show branch / commit info in the window title bar
      },

      -- Merge conflict view: base in the centre, ours on the left, theirs on the right.
      -- disable_diagnostics avoids LSP noise on conflict marker syntax errors.
      merge_tool = {
        layout = "diff3_mixed",
        disable_diagnostics = true,
      },

      -- File history uses the same two-pane layout as the standard diff.
      file_history = {
        layout = "diff2_horizontal",
        winbar_info = true,
      },
    },

    -- ─── File Panel (sidebar) ──────────────────────────────────
    -- Lists every changed file in the current diff session.
    file_panel = {
      listing_style = "tree", -- Show files inside their directory hierarchy
      win_config = {
        position = "left",
        width = 35,
      },
    },

    -- ─── File History Panel ────────────────────────────────────
    -- The commit log panel shown at the bottom during :DiffviewFileHistory.
    file_history_panel = {
      win_config = {
        position = "bottom",
        height = 16,
      },
    },

    -- ─── Default Keymaps ───────────────────────────────────────
    keymaps = {
      -- Keep the built-in diffview keymaps intact.
      -- Set disable_defaults = true only if you want full manual control.
      disable_defaults = false,
    },
  },
}
