-- ═══════════════════════════════════════════════════════════
-- NEOVIM KEYMAPS - Custom Keymaps
-- ═══════════════════════════════════════════════════════════
--
-- Description:
--   Sets up custom keymaps for Neovim using the vim.keymap API.
--   Improves navigation speed, remaps commonly used keys, and
--   adds utility commands.
--
-- Location:
--   ~/.config/nvim/lua/config/keymaps.lua
--
-- Installation:
--   Loaded automatically by lazy.nvim (no manual require needed).
--
-- See also:
--   nvim/lua/config/options.lua   (editor settings)
--   nvim/lua/config/autocmds.lua  (autocommands)
--   nvim/lua/config/lazy.lua      (plugin manager entry point)
--
-- Documentation:
--   https://neovim.io/doc/user/mapping.html

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

-- ─── Select All ────────────────────────────────────────────────────────────────
-- Maps <leader>sa to select all content in the current buffer.
-- 'gg' moves to the first line, 'V' starts visual line mode, 'G' jumps to
-- the last line — selecting everything in between.
keymap.set("n", "<leader>sa", "ggVG", { noremap = true, silent = true, desc = "Select All" })

-- ─── Move Lines ────────────────────────────────────────────────────────────────
-- Alt+J / Alt+K moves the current line (or visual selection) up or down.
-- After the move, the line/selection is re-indented to fit the new context.
-- In visual mode, `gv` preserves the selection so you can spam Alt+J/K.
keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- ─── Duplicate Line ────────────────────────────────────────────────────────────
-- <leader>dd yanks the current line (`yy`) and pastes it below (`p`).
-- This shadows LazyVim's debug disconnect mapping — if you use a debugger,
-- consider remapping to something else.
keymap.set("n", "<leader>dd", "yyp", { desc = "Duplicate line" })

-- ─── Quick Save ───────────────────────────────────────────────────────────────
-- Moved from <leader>w to <leader>fs to avoid conflicting with the
-- "Window" group declared in which-key.lua.
keymap.set("n", "<leader>fs", "<cmd>w<cr>", { noremap = true, desc = "Save file" })

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

-- ─── Toggle Terminal ────────────────────────────────────────────────────────────
-- Opens LazyTerm in a float (<leader>tt), toggles it closed on second press.
-- LazyVim provides lazyterm as a floating terminal; this is just the toggle key.
vim.keymap.set("n", "<leader>tt", function()
  Snacks.terminal.toggle()
end, { desc = "[T]oggle [T]erminal (LazyTerm)" })
