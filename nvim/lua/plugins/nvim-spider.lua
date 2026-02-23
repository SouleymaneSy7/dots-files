-- ═══════════════════════════════════════════════════════════
-- PLUGINS - nvim-spider (Smarter Word Motion)
-- ═══════════════════════════════════════════════════════════
--
-- Overrides the default w, e, and b word motion keys with smarter
-- versions that respect camelCase, snake_case, and subword boundaries,
-- making navigation through identifiers more precise.

return {
  "chrisgrieser/nvim-spider",

  opts = {}, -- Use default plugin options

  -- ─── Keymaps ───────────────────────────────────────────────
  -- Remaps w, e, and b to spider's motion functions in normal,
  -- operator-pending, and visual modes. This means spider motions
  -- also work as text objects (e.g. dw, ce, vb).
  keys = {
    {
      "w",
      "<cmd>lua require('spider').motion('w')<CR>",
      mode = { "n", "o", "x" },
      desc = "Move to start of next of word",
    },
    {
      "e",
      "<cmd>lua require('spider').motion('e')<CR>",
      mode = { "n", "o", "x" },
      desc = "Move to end of word",
    },
    {
      "b",
      "<cmd>lua require('spider').motion('b')<CR>",
      mode = { "n", "o", "x" },
      desc = "Move to start of previous word",
    },
  },
}
