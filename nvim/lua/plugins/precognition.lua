-- ═══════════════════════════════════════════════════════════
-- PLUGINS - precognition.nvim (Motion Hints)
-- ═══════════════════════════════════════════════════════════
--
-- Vim motions and commands for Precognition
-- Displays virtual text hints directly in the buffer to teach and
-- remind the user of available Vim motions at the current cursor position.

return {
  "tris203/precognition.nvim",

  -- Load after the UI is ready; hints are not needed during startup.
  event = "VeryLazy",

  opts = {
    -- Show motion hints immediately when Neovim starts,
    -- without requiring a manual toggle command.
    startVisible = true,

    -- Insert a blank virtual line to prevent hints from overlapping
    -- with actual buffer content on dense or short lines.
    showBlankVirtLine = true,

    -- Link the hint highlight group to "Comment" so hints are visually
    -- subtle and don't distract from the actual buffer content.
    highlightColor = { link = "Comment" },

    -- ─── Inline Hints ──────────────────────────────────────────
    -- Defines the motion hints displayed inline within the current line.
    -- Each hint has a display text and a priority (prio); higher priority
    -- hints are shown first when space is limited.
    hints = {
      Caret = { text = "^", prio = 2 }, -- Jump to first non-blank character of the line
      Dollar = { text = "$", prio = 1 }, -- Jump to end of line
      MatchingPair = { text = "%", prio = 5 }, -- Jump to matching bracket/paren/brace
      Zero = { text = "0", prio = 1 }, -- Jump to the very beginning of the line
      w = { text = "w", prio = 10 }, -- Jump to start of next word
      b = { text = "b", prio = 9 }, -- Jump to start of previous word
      e = { text = "e", prio = 8 }, -- Jump to end of current/next word
      W = { text = "W", prio = 7 }, -- Jump to start of next WORD (whitespace-delimited)
      B = { text = "B", prio = 6 }, -- Jump to start of previous WORD
      E = { text = "E", prio = 5 }, -- Jump to end of current/next WORD
    },

    -- ─── Gutter Hints ──────────────────────────────────────────
    -- Defines motion hints displayed in the sign column / gutter,
    -- used for vertical navigation motions that span multiple lines.
    gutterHints = {
      G = { text = "G", prio = 10 }, -- Jump to last line of the buffer
      gg = { text = "gg", prio = 9 }, -- Jump to first line of the buffer
      PrevParagraph = { text = "{", prio = 8 }, -- Jump to start of the previous paragraph
      NextParagraph = { text = "}", prio = 8 }, -- Jump to start of the next paragraph
    },
  },
}
