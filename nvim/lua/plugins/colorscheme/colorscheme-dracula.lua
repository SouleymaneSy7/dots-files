-- ═══════════════════════════════════════════════════════════
-- PLUGINS - dracula.nvim (Colorscheme)
-- ═══════════════════════════════════════════════════════════
--
-- Installs the Dracula colorscheme and sets it as the active
-- colorscheme for the entire Neovim environment via LazyVim.

return {
  -- ─── Dracula Theme ─────────────────────────────────────────
  -- Registers the Dracula colorscheme plugin with default settings.
  -- No opts are needed as the default Dracula palette is used as-is.
  { "Mofiqul/dracula.nvim" },

  -- ─── LazyVim Colorscheme Activation ────────────────────────
  -- Tells LazyVim which colorscheme to apply on startup.
  -- This must match the identifier registered by dracula.nvim.
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "dracula",
    },
  },
}
