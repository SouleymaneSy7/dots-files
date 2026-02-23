-- ═══════════════════════════════════════════════════════════
-- PLUGINS - palenightfall.nvim (Colorscheme)
-- ═══════════════════════════════════════════════════════════
--
-- Installs the Palenightfall colorscheme and sets it as the active
-- colorscheme for the entire Neovim environment via LazyVim.

return {
  -- ─── Palenightfall Theme ────────────────────────────────────
  -- Registers the Palenightfall colorscheme plugin with default settings.
  -- No opts are needed as the default Palenightfall palette is used as-is.
  { "JoosepAlviste/palenightfall.nvim" },

  -- ─── LazyVim Colorscheme Activation ────────────────────────
  -- Tells LazyVim which colorscheme to apply on startup.
  -- This must match the identifier registered by palenightfall.nvim.
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "palenightfall",
    },
  },
}
