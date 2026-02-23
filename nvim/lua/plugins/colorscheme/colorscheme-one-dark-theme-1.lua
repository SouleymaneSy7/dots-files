-- ═══════════════════════════════════════════════════════════
-- PLUGINS - onedark.nvim (Colorscheme)
-- ═══════════════════════════════════════════════════════════
--
-- Configures the OneDark colorscheme and sets it as the active
-- colorscheme for the entire Neovim environment via LazyVim.

return {
  {
    "navarasu/onedark.nvim",

    -- Load immediately at startup (not deferred) since the colorscheme
    -- must be applied before any UI elements are rendered.
    lazy = false,

    -- High priority ensures this plugin loads before others that might
    -- depend on highlight groups being defined (e.g. statusline, lualine).
    priority = 1000,

    opts = {
      -- ─── Style Variant ─────────────────────────────────────────
      -- Selects the color palette variant for OneDark.
      -- Available options: 'dark' | 'darker' | 'deep' | 'cool' | 'warm' | 'warmer'
      style = "deep",

      -- ─── Transparency ──────────────────────────────────────────
      -- When set to true, the background color is cleared so the
      -- terminal's own background shows through (useful for terminal transparency).
      transparent = false,

      -- ─── Code Syntax Styling ───────────────────────────────────
      -- Controls the font style applied to each syntax category.
      -- Accepted values per key: "none" | "bold" | "italic" | "underline" | combinations
      code_style = {
        comments = "italic", -- Comments rendered in italic for visual distinction
        keywords = "bold", -- Keywords (if, for, return, etc.) rendered in bold
        functions = "none", -- Function names use default weight/style
        strings = "none", -- String literals use default weight/style
        variables = "none", -- Variables use default weight/style
      },

      -- ─── Diagnostics Appearance ────────────────────────────────
      -- Controls how LSP diagnostic highlights (errors, warnings, hints) are rendered.
      diagnostics = {
        darker = true, -- Use darker shades for diagnostic highlight backgrounds
        undercurl = true, -- Underline diagnostics with a wavy curl instead of a straight line
        background = true, -- Apply a background color to diagnostic regions for visibility
      },
    },
  },

  {
    -- Tells LazyVim which colorscheme to activate on startup.
    -- This must match the plugin name/identifier registered by onedark.nvim.
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "onedark",
    },
  },
}
