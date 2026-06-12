-- ═══════════════════════════════════════════════════════════
-- PLUGINS - nightfox.nvim (Colorscheme)
-- ═══════════════════════════════════════════════════════════
--
-- Documentation: https://github.com/EdenEast/nightfox.nvim

return {
  {
    "EdenEast/nightfox.nvim",

    -- Load immediately at startup — the colorscheme must be applied before
    -- any other plugin defines its highlight groups.
    lazy = false,
    priority = 1000,

    opts = {
      options = {
        -- ─── Compilation ───────────────────────────────────────────
        -- Compiles the colorscheme to a Lua bytecode cache for faster startup.
        compile_path = vim.fn.stdpath("cache") .. "/nightfox",
        compile_file_suffix = "_compiled",

        -- ─── Transparency ──────────────────────────────────────────
        -- Keep false to match Ghostty's opaque background.
        -- Set to true only if background-opacity is enabled in config.ghostty.
        transparent = false,

        -- ─── Terminal Colors ───────────────────────────────────────
        -- Apply the Nightfox palette to terminal colors inside Neovim.
        terminal_colors = true,

        -- ─── Dimming ───────────────────────────────────────────────
        -- Dims non-focused split windows for focus clarity.
        dim_inactive = false,

        -- ─── Module Visibility ─────────────────────────────────────
        -- Global module toggles. Individual modules can override this.
        module_default = true,

        -- ─── Code Syntax Styling ───────────────────────────────────
        styles = {
          comments = "italic", -- Comments in italic for visual distinction
          keywords = "bold", -- Language keywords in bold
          functions = "bold", -- Functions: default style
          strings = "NONE", -- String literals: default style
          variables = "NONE", -- Variables: default style
          numbers = "NONE",
          booleans = "bold",
          conditionals = "bold", -- if/else/switch in bold
          constants = "bold",
          types = "bold",
          operators = "NONE",
        },

        -- ─── Inverse Highlights ────────────────────────────────────
        inverse = {
          match_paren = false, -- Do not invert matching parenthesis highlights
          visual = false, -- Do not invert visual selection highlight
          search = false, -- Do not invert search highlights
        },
      },

      -- ─── Palette Overrides ─────────────────────────────────────
      -- Fine-grained palette token overrides per variant.
      -- Uncomment and adjust as needed.
      -- palettes = {
      --   nordfox = { bg1 = "#2e3440" },
      -- },

      -- ─── Spec Overrides ────────────────────────────────────────
      -- Override derived specification values (syntax, UI tokens).
      -- specs = {},

      -- ─── Highlight Group Overrides ─────────────────────────────
      -- Direct overrides for any highlight group.
      -- groups = {},
    },
  },

  -- ─── LazyVim Colorscheme Activation ────────────────────────
  -- Available variants: "nightfox" | "dayfox" | "dawnfox" |
  --                     "duskfox" | "nordfox" | "terafox" | "carbonfox"
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "nightfox" },
  },
}
