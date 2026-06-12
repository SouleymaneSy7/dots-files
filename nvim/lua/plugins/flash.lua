-- ═══════════════════════════════════════════════════════════
-- PLUGINS - flash.nvim (Fast Jump Navigation)
-- ═══════════════════════════════════════════════════════════
--
-- Extends LazyVim's built-in flash.nvim config with rainbow labels,
-- fuzzy search integration, and per-mode tweaks.
-- flash lets you jump to any visible position in 2-3 keystrokes.
--
-- Core keymaps (extend LazyVim defaults):
--   s        → jump to any position (normal / visual / operator)
--   S        → jump to a Treesitter syntax node
--   r        → remote flash (apply an operator on a distant target)
--   R        → treesitter search across the whole buffer
--   <c-s>    → toggle flash overlay inside / and ? search

return {
  "folke/flash.nvim",

  opts = {
    -- ─── Labels ────────────────────────────────────────────────
    -- Characters used to build jump labels.
    -- Home-row keys come first to minimize finger travel.
    labels = "asdfghjklqwertyuiopzxcvbnm",

    -- ─── Search Integration ────────────────────────────────────
    -- When enabled, flash overlays labels on / and ? results so you
    -- can jump directly to any match without pressing <CR> first.
    search = {
      enabled = true, -- Activate during incremental search
      mode = "fuzzy", -- Accept non-consecutive characters (faster to type)
      incremental = true, -- Re-compute labels after each typed character
    },

    -- ─── Jump Behavior ─────────────────────────────────────────
    jump = {
      -- Do not auto-jump when only one label is left; wait for the label key.
      -- This prevents accidental jumps when the search narrows to one match.
      autojump = false,
    },

    -- ─── Label Appearance ──────────────────────────────────────
    label = {
      uppercase = false, -- Lowercase labels are faster to type
      rainbow = { enabled = true, shade = 5 }, -- Color each label differently so
      -- nearby labels are easy to distinguish
    },

    -- ─── Mode-Specific Overrides ───────────────────────────────
    modes = {
      -- f / F / t / T motions: show labels immediately after the first keystroke
      -- so you can land on any matching character on the line in one extra key.
      char = {
        jump_labels = true,
        multi_line = false, -- Restrict char-mode labels to the current line
      },
    },
  },
}
