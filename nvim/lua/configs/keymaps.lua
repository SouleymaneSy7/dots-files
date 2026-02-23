-- ═══════════════════════════════════════════════════════════
-- NEOVIM KEYMAPS - Custom Keymaps
-- ═══════════════════════════════════════════════════════════
--
-- This module sets up custom keymaps for Neovim using the vim.keymap API.
-- It improves navigation speed, remaps commonly used keys, and adds utility commands.

local keymap = vim.keymap

-- ─── Insert Mode Escape Shortcuts ────────────────────────────────────────────
-- Map 'jk' and 'kj' to <ESC> in insert mode for a faster way to return to normal mode.
-- 'noremap' prevents recursive remapping; 'silent' suppresses command-line output.
keymap.set("i", "jk", "<ESC>", { noremap = true, silent = true, desc = "<ESC>" })
keymap.set("i", "kj", "<ESC>", { noremap = true, silent = true, desc = "<ESC>" })

-- ─── Faster Vertical Navigation ──────────────────────────────────────────────
-- Override 'K' and 'J' in normal and visual modes to jump 10 lines at a time
-- instead of their default behavior (lookup keyword / join lines).
keymap.set({ "n", "v" }, "K", "10k", { noremap = true, desc = "Up faster" })
keymap.set({ "n", "v" }, "J", "10j", { noremap = true, desc = "Down faster" })

-- ─── Restore Original K and J via Leader ─────────────────────────────────────
-- Since K and J were overridden above, these mappings restore their original
-- Vim behavior under the <leader> prefix:
--   <leader>k → K (show keyword / LSP hover in some configs)
--   <leader>j → J (join current line with the line below)
keymap.set({ "n", "v" }, "<leader>k", "K", { noremap = true, desc = "Keyword" })
keymap.set({ "n", "v" }, "<leader>j", "J", { noremap = true, desc = "Join lines" })

-- ─── Quick Save ───────────────────────────────────────────────────────────────
-- <leader>w triggers the ':w' write command in normal mode, saving the current buffer.
keymap.set("n", "<leader>w", "<cmd>w<cr>", { noremap = true, desc = "Save window" })

-- ─── LSP Hover ────────────────────────────────────────────────────────────────
-- 'gh' in normal mode triggers vim.lsp.buf.hover(), which displays documentation
-- or type information for the symbol under the cursor via the active LSP server.
keymap.set("n", "gh", function()
  vim.lsp.buf.hover()
end)

-- ─── Toggle Folding ───────────────────────────────────────────────────────────
-- <leader>uF toggles the global 'foldenable' option on/off.
-- When enabled, Vim will collapse folds; when disabled, all folds are shown open.
vim.keymap.set("n", "<leader>uF", function()
  vim.o.foldenable = not vim.o.foldenable
end, { desc = "Toggle [U]I [F]olding" })

-- ─── CopyPath User Command ────────────────────────────────────────────────────
-- Registers a custom Ex command ':CopyPath' that:
--   1. Resolves the absolute path of the currently open file using expand("%:p").
--   2. Writes that path into the system clipboard register ("+").
--   3. Displays a notification confirming the copied path.
-- Useful when you need to reference the current file's path in a terminal or another app.
vim.api.nvim_create_user_command("CopyPath", function()
  local file_path = vim.fn.expand("%:p")
  vim.fn.setreg("+", file_path)
  vim.notify("Copied path: " .. file_path)
end, { nargs = 0, desc = "Copy full path of current file to clipboard" })
