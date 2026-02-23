-- ═══════════════════════════════════════════════════════════
-- PLUGINS - onedark.vim (Colorscheme)
-- ═══════════════════════════════════════════════════════════
--
-- Installs the OneDark colorscheme and sets it as the active
-- colorscheme for the entire Neovim environment via LazyVim.

return {
  -- ─── OneDark Theme ─────────────────────────────────────────
  -- Registers the OneDark colorscheme plugin with default settings.
  -- No opts are needed as the default OneDark palette is used as-is.
  { "joshdick/onedark.vim" },

  -- ─── LazyVim Colorscheme Activation ────────────────────────
  -- Tells LazyVim which colorscheme to apply on startup.
  -- This must match the identifier registered by onedark.vim.
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "onedark",
    },
  },
}
