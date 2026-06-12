-- ═══════════════════════════════════════════════════════════
-- PLUGINS - harpoon (v2) (Quick File Bookmarks)
-- ═══════════════════════════════════════════════════════════
--
-- Maintains a small persistent list of frequently-used files per
-- project. Switching between them is instant: one keymap, no fuzzy
-- finder, no explorer. Perfect for the 4-5 files you touch the most.
--
-- Workflow:
--   <leader>ha  → add current file to the list
--   <leader>hh  → open the quick-menu to view / reorder / remove
--   <leader>h1  → jump directly to slot 1  (and so on up to 4)
--   <leader>hp  → previous file in the list
--   <leader>hn  → next file in the list

return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",

  dependencies = {
    "nvim-lua/plenary.nvim", -- Required async + path utilities
  },

  event = "VeryLazy",

  opts = {
    settings = {
      -- Write the list to disk whenever the quick-menu is closed.
      save_on_toggle = true,

      -- Sync to disk when the UI is dismissed by any means (not just toggle).
      sync_on_ui_close = true,

      -- Scope the harpoon list to the current working directory so
      -- each project keeps its own independent file list.
      key = function()
        return vim.loop.cwd()
      end,
    },
  },

  -- ─── Keymaps ───────────────────────────────────────────────
  -- Defined as a function so `require("harpoon")` is deferred until
  -- the plugin is actually loaded (lazy-loading safe).
  keys = function()
    local harpoon = require("harpoon")

    return {
      -- ─── List Management ──────────────────────────────────────
      {
        "<leader>ha",
        function()
          harpoon:list():add()
        end,
        desc = "Add file",
      },
      {
        "<leader>hh",
        function()
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = "Quick menu",
      },

      -- ─── Direct Slot Access ────────────────────────────────────
      -- Jump to a specific position in the list without opening the menu.
      {
        "<leader>h1",
        function()
          harpoon:list():select(1)
        end,
        desc = "File 1",
      },
      {
        "<leader>h2",
        function()
          harpoon:list():select(2)
        end,
        desc = "File 2",
      },
      {
        "<leader>h3",
        function()
          harpoon:list():select(3)
        end,
        desc = "File 3",
      },
      {
        "<leader>h4",
        function()
          harpoon:list():select(4)
        end,
        desc = "File 4",
      },

      -- ─── Sequential Navigation ────────────────────────────────
      -- Cycle through the list in order (wraps around at both ends).
      {
        "<leader>hp",
        function()
          harpoon:list():prev()
        end,
        desc = "Prev file",
      },
      {
        "<leader>hn",
        function()
          harpoon:list():next()
        end,
        desc = "Next file",
      },
    }
  end,
}
