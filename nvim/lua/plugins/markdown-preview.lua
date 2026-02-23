-- ═══════════════════════════════════════════════════════════
-- PLUGINS - markdown-preview.nvim (Markdown Live Preview)
-- ═══════════════════════════════════════════════════════════
--
-- Opens a live-updating preview of the current Markdown file
-- in the browser. The preview syncs with the cursor position in Neovim.

return {
  "iamcco/markdown-preview.nvim",

  -- Only load the plugin when one of these commands is explicitly invoked,
  -- keeping it out of memory for non-Markdown workflows.
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },

  -- ─── Build Step ────────────────────────────────────────────
  -- Runs once after installation to compile the plugin's Node.js dependencies.
  -- Forces lazy.nvim to load the plugin first so its runtime files are available,
  -- then calls the bundled install script to set up the preview server binary.
  build = function()
    require("lazy").load({ plugins = { "markdown-preview.nvim" } })
    vim.fn["mkdp#util#install"]()
  end,

  -- ─── Keymaps ───────────────────────────────────────────────
  -- Defines keymaps that are only active in Markdown buffers (ft = "markdown").
  -- <leader>cp toggles the browser preview on and off.
  keys = {
    {
      "<leader>cp",
      ft = "markdown", -- Keymap is scoped to markdown filetype only
      "<cmd>MarkdownPreviewToggle<cr>",
      desc = "Markdown Preview",
    },
  },

  -- ─── Config ────────────────────────────────────────────────
  -- Re-triggers the FileType autocommand after the plugin loads.
  -- This ensures markdown-preview registers its filetype hooks correctly
  -- when the plugin is loaded lazily on an already-open Markdown buffer.
  config = function()
    vim.cmd([[do FileType]])
  end,
}
