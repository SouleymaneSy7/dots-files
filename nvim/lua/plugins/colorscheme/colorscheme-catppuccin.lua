-- ═══════════════════════════════════════════════════════════
-- PLUGINS - catppuccin.nvim (Colorscheme)
-- ═══════════════════════════════════════════════════════════
--
-- Documentation: https://github.com/catppuccin/nvim

return {
  {
    "catppuccin/nvim",

    -- The plugin name must be "catppuccin" for LazyVim to recognize it.
    name = "catppuccin",

    -- Load immediately at startup — the colorscheme must be applied before
    -- any other plugin defines its highlight groups.
    lazy = false,
    priority = 1000,

    opts = {
      -- ─── Variant ─────────────────────────────────────────────
      -- Macchiato is used across every tool in this project.
      -- Other options: "latte" (light), "frappe", "mocha" (darkest).
      flavour = "macchiato",

      -- ─── Transparency ────────────────────────────────────────
      -- Keep false to match Ghostty's opaque background.
      -- Set to true only if background-opacity is enabled in config.ghostty.
      transparent_background = false,

      -- ─── Code Syntax Styling ─────────────────────────────────
      styles = {
        comments = { "italic" }, -- Comments in italic for visual distinction
        conditionals = { "bold" }, -- if/else/switch in bold
        keywords = { "bold" }, -- Language keywords in bold
        functions = {}, -- Functions: default style
        variables = {}, -- Variables: default style
        strings = {}, -- String literals: default style
        numbers = {},
        booleans = { "bold" },
        properties = {},
        types = { "bold" },
        operators = {},
      },

      -- ─── Plugin Integrations ─────────────────────────────────
      -- Enable Catppuccin-specific highlight groups for each plugin.
      integrations = {
        cmp = true,
        gitsigns = true,
        neotree = true, -- neo-tree: LazyVim's default file explorer
        treesitter = true,
        telescope = { enabled = true },
        lsp_trouble = true,
        which_key = true,
        indent_blankline = { enabled = true },
        mini = { enabled = true, indentscope_color = "" },
        notify = true,
        noice = true,
        mason = true,
        snacks = true,
        native_lsp = {
          enabled = true,
          -- Use undercurl for diagnostics instead of background highlights.
          -- Less intrusive — does not interfere with code readability.
          underlines = {
            errors = { "undercurl" },
            hints = { "underdotted" },
            warnings = { "undercurl" },
            information = { "underdotted" },
          },
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
          inlay_hints = { background = true },
        },
      },

      -- ─── Custom Highlight Groups ─────────────────────────────
      -- Targeted overrides for elements not covered by integrations,
      -- or to fine-tune specific visual details.
      custom_highlights = function(colors)
        return {
          -- Relative line numbers are more subdued than the cursor line number.
          LineNrAbove = { fg = colors.overlay0 },
          LineNrBelow = { fg = colors.overlay0 },

          -- Cursor line number stands out in mauve to mark the current position.
          CursorLineNr = { fg = colors.mauve, bold = true },

          -- Cursor line background is very subtle — just enough to locate the cursor.
          CursorLine = { bg = colors.surface0 },
        }
      end,
    },
  },

  -- ─── LazyVim Colorscheme Activation ──────────────────────
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "catppuccin-macchiato" },
  },
}
