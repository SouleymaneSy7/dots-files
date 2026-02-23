-- ═══════════════════════════════════════════════════════════
-- PLUGINS - yanky.nvim (Enhanced Yank & Paste)
-- ═══════════════════════════════════════════════════════════
--
-- Extends Neovim's built-in yank and paste with a persistent yank ring,
-- system clipboard sync, paste highlighting, and advanced put motions.

return {
  "gbprod/yanky.nvim",
  recommended = true,
  desc = "Better Yank/Paste",

  -- Load when a file is opened (LazyFile), since yank/paste is only
  -- relevant in the context of an active buffer.
  event = "LazyFile",

  -- ─── Yank Ring Configuration ───────────────────────────────
  -- Controls the behavior of the yank history ring that stores
  -- previous yanks and allows cycling through them on paste.
  ring = {
    history_length = 1000, -- Keep the last 1000 yanked entries in history
    storage = "shada", -- Persist the ring to ShaDa file so history survives restarts
    sync_with_numbered_registers = true, -- Keep numbered registers (0-9) in sync with the ring
    cancel_event = "update", -- Clear the active ring cycle when the buffer is updated
    ignore_registers = { "_" }, -- Never store yanks from the black hole register
    update_register_on_cycle = false, -- Do not overwrite the default register when cycling history
    permanent_wrapper = nil, -- No permanent transform applied to yanked text
  },

  opts = {
    -- ─── System Clipboard ──────────────────────────────────────
    -- Syncs the yank ring with the system clipboard unless Neovim is
    -- running inside an SSH session, where clipboard sync is unavailable.
    system_clipboard = {
      sync_with_ring = not vim.env.SSH_CONNECTION,
    },

    -- ─── Highlight ─────────────────────────────────────────────
    -- Briefly highlights yanked text for 150ms to give visual feedback
    -- confirming what was yanked, similar to vim-highlightedyank.
    highlight = { timer = 150 },
  },

  -- ─── Keymaps ───────────────────────────────────────────────
  keys = {
    -- ─── Yank History Picker ─────────────────────────────────
    -- <leader>p opens the yank history using whichever picker is active:
    -- telescope, snacks, or the built-in YankyRingHistory command.
    {
      "<leader>p",
      function()
        if LazyVim.pick.picker.name == "telescope" then
          require("telescope").extensions.yank_history.yank_history({})
        elseif LazyVim.pick.picker.name == "snacks" then
          Snacks.picker.yanky()
        else
          vim.cmd([[YankyRingHistory]])
        end
      end,
      mode = { "n", "x" },
      desc = "Open Yank History",
    },

    -- ─── Core Yank / Put Motions ─────────────────────────────
    -- stylua: ignore
    { "y",    "<Plug>(YankyYank)",                       mode = { "n", "x" }, desc = "Yank text" },
    { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put yanked text after cursor" },
    { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before cursor" },

    -- ─── GPut Motions (cursor stays after pasted text) ───────
    {
      "gp",
      "<Plug>(YankyGPutAfter)",
      mode = { "n", "x" },
      desc = "Put yanked text after cursor and leave cursor after",
    },
    {
      "gP",
      "<Plug>(YankyGPutBefore)",
      mode = { "n", "x" },
      desc = "Put yanked text before cursor and leave cursor after",
    },

    -- ─── Ring Cycling ────────────────────────────────────────
    -- After a paste, cycle backward/forward through the yank ring
    -- to replace the pasted text with a previous or next yank entry.
    { "<c-p>", "<Plug>(YankyPreviousEntry)", desc = "Select previous entry through yank history" },
    { "<c-n>", "<Plug>(YankyNextEntry)", desc = "Select next entry through yank history" },

    -- ─── Indented Put (Linewise) ─────────────────────────────
    -- Paste with automatic indentation matching the surrounding code.
    { "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put indented after cursor (linewise)" },
    { "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put indented before cursor (linewise)" },
    { "]P", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put indented after cursor (linewise)" },
    { "[P", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put indented before cursor (linewise)" },

    -- ─── Shifted Put ─────────────────────────────────────────
    -- Paste and immediately shift the pasted text left or right.
    { ">p", "<Plug>(YankyPutIndentAfterShiftRight)", desc = "Put and indent right" },
    { "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", desc = "Put and indent left" },
    { ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", desc = "Put before and indent right" },
    { "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", desc = "Put before and indent left" },

    -- ─── Filtered Put ────────────────────────────────────────
    -- Paste after applying a transformation filter to the yanked text.
    { "=p", "<Plug>(YankyPutAfterFilter)", desc = "Put after applying a filter" },
    { "=P", "<Plug>(YankyPutBeforeFilter)", desc = "Put before applying a filter" },
  },
}
