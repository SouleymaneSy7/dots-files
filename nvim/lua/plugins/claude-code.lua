-- ═══════════════════════════════════════════════════════════
-- PLUGINS - claudecode.nvim (Claude AI Integration)
-- ═══════════════════════════════════════════════════════════
--
-- Integrates Claude AI directly into Neovim via claudecode.nvim.
-- Allows sending code, buffers, and files to Claude, managing
-- AI-suggested diffs, and controlling the Claude session from within the editor.

return {
  "coder/claudecode.nvim",

  -- snacks.nvim is required for the terminal UI used to display
  -- the Claude Code session window inside Neovim.
  dependencies = { "folke/snacks.nvim" },

  -- config = true tells lazy.nvim to call require("claudecode").setup()
  -- with default options, since no custom opts table is needed.
  config = true,

  -- ─── Keymaps ───────────────────────────────────────────────
  keys = {
    -- ─── Group Label ─────────────────────────────────────────
    -- Registers <leader>a as the AI/Claude Code group prefix for which-key.
    -- nil action means this key alone does nothing; it only labels the group.
    { "<leader>a", nil, desc = "AI/Claude Code" },

    -- ─── Session Management ──────────────────────────────────
    { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" }, -- Open or close the Claude session window
    { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" }, -- Move focus to the Claude session window
    { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" }, -- Resume the most recently interrupted Claude session
    { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" }, -- Continue Claude's last response or action
    { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" }, -- Open model selector to switch between Claude versions

    -- ─── Context & Input ─────────────────────────────────────
    { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" }, -- Send the entire current buffer as context to Claude
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" }, -- Send the current visual selection to Claude

    -- File explorer integration: add a file directly from the tree to Claude's context.
    -- Only active when the current buffer is a supported file explorer filetype.
    {
      "<leader>as",
      "<cmd>ClaudeCodeTreeAdd<cr>",
      desc = "Add file",
      ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
    },

    -- ─── Diff Management ─────────────────────────────────────
    -- When Claude suggests code changes as a diff, these keymaps
    -- allow accepting or rejecting the proposed modifications.
    { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" }, -- Apply Claude's suggested changes to the buffer
    { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" }, -- Reject Claude's suggested changes and restore original
  },
}
