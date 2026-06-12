-- ═══════════════════════════════════════════════════════════
-- PLUGINS - tokyonight.nvim (Colorscheme)
-- ═══════════════════════════════════════════════════════════
--
-- Documentation: https://github.com/folke/tokyonight.nvim

return {
  {
    "folke/tokyonight.nvim",

    -- Load immediately at startup — the colorscheme must be applied before
    -- any other plugin defines its highlight groups.
    lazy = false,
    priority = 1000,

    opts = {
      -- ─── Style Variant ─────────────────────────────────────────
      -- Selects the color palette variant for TokyoNight.
      -- Available options: "night" | "storm" | "day" | "moon"
      style = "moon",

      -- ─── Transparency ──────────────────────────────────────────
      -- Keep false to match Ghostty's opaque background.
      -- Set to true only if background-opacity is enabled in config.ghostty.
      transparent = false,

      -- ─── Terminal Colors ───────────────────────────────────────
      -- Apply the TokyoNight palette to terminal colors inside Neovim.
      terminal_colors = true,

      -- ─── Code Syntax Styling ───────────────────────────────────
      styles = {
        comments = { italic = true }, -- Comments in italic for visual distinction
        keywords = { bold = true }, -- Language keywords in bold
        functions = {}, -- Functions: default style
        variables = {}, -- Variables: default style
        sidebars = "dark", -- Background for sidebars (NeoTree, etc.)
        floats = "dark", -- Background for floating windows
      },

      -- ─── Sidebars ──────────────────────────────────────────────
      -- List of filetypes that receive the sidebar background style.
      sidebars = { "qf", "help", "neo-tree", "Trouble", "lazy", "mason" },

      -- ─── Day Style Brightness ──────────────────────────────────
      -- Only applies when style = "day".
      day_brightness = 0.3,

      -- ─── Dim Inactive Windows ──────────────────────────────────
      -- Slightly dims non-focused split windows for focus clarity.
      dim_inactive = false,

      -- ─── Plugin Integrations ───────────────────────────────────
      -- TokyoNight ships integration highlights for many plugins.
      -- All are enabled by default; selectively disable if needed.
      plugins = {
        auto = true, -- Auto-detect and enable all installed plugin integrations
      },
    },
  },

  -- ─── LazyVim Colorscheme Activation ────────────────────────
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "tokyonight-moon" },
  },
}
