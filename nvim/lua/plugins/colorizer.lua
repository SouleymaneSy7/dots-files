-- ═══════════════════════════════════════════════════════════
-- PLUGINS - nvim-colorizer.lua (Color Highlighter)
-- ═══════════════════════════════════════════════════════════
--
-- Colors (hex, rgb, hsl, etc.) highlighter for neovim
-- This plugin visually highlights color codes directly in the buffer,
-- rendering them with their actual color as a background or foreground swatch.
return {
  {
    "catgoose/nvim-colorizer.lua",

    -- Only load the plugin when a buffer is about to be read,
    -- avoiding any startup time cost on launch.
    event = "BufReadPre",

    opts = {
      -- Filetypes to enable colorizer on.
      -- "*" means all filetypes; "!vim", "!lazy", "!prompt", "!popup" explicitly exclude
      -- those filetypes to avoid visual noise or conflicts in Neovim's own UI buffers.
      -- cmp_docs always updates highlights so color previews stay accurate in completion docs.
      filetypes = { "*", "!vim", "!lazy", "!prompt", "!popup", cmp_docs = { always_update = true } },

      buftypes = {}, -- No buffer type restrictions; applies to all buffer types by default

      -- Defer attaching colorizer to buffers until they are actually visited,
      -- reducing startup overhead when many buffers are open.
      lazy_load = true,

      user_default_options = {
        names_custom = false, -- Custom names to be highlighted: table|function|false

        -- ─── Hex Color Format Support ──────────────────────────────
        RGB = true, -- Highlight shorthand 3-digit hex colors e.g. #RGB
        RGBA = true, -- Highlight shorthand 4-digit hex colors e.g. #RGBA
        RRGGBB = true, -- Highlight standard 6-digit hex colors e.g. #RRGGBB
        RRGGBBAA = true, -- Highlight 8-digit hex with alpha channel e.g. #RRGGBBAA
        AARRGGBB = false, -- Highlight 0x-prefixed hex with leading alpha e.g. 0xAARRGGBB (disabled)

        -- ─── CSS Function Support ───────────────────────────────────
        rgb_fn = true, -- Highlight CSS rgb() and rgba() functional notation
        hsl_fn = true, -- Highlight CSS hsl() and hsla() functional notation
        oklch_fn = true, -- Highlight CSS oklch() perceptual color function (modern CSS)

        -- ─── CSS Shorthand Toggles ──────────────────────────────────
        css = true, -- Master toggle: enables all CSS color features at once
        -- (names, RGB, RGBA, RRGGBB, RRGGBBAA, AARRGGBB, rgb_fn, hsl_fn, oklch_fn)
        css_fn = true, -- Enable all CSS color functions at once: rgb_fn, hsl_fn, oklch_fn

        -- ─── Tailwind CSS Support ───────────────────────────────────
        -- Highlights Tailwind utility class color names (e.g. "bg-blue-500").
        -- 'normal' uses the built-in name table; 'lsp' uses LSP-provided colors;
        -- 'both' merges both sources for maximum coverage.
        tailwind = "both",
        tailwind_opts = {
          -- When using tailwind = 'both', keep the local name table in sync
          -- with any updated color values returned by the Tailwind LSP server.
          update_names = true,
        },

        -- ─── Sass Support ───────────────────────────────────────────
        -- Enables color highlighting inside .scss/.sass files.
        -- The parsers table reuses the css and css_fn parsers so Sass-specific
        -- color syntax (variables resolving to colors) is also highlighted.
        sass = { enable = true, parsers = { css = true, css_fn = true } },

        -- ─── Display Mode ───────────────────────────────────────────
        -- "background": renders the color as the cell's background color.
        -- Other options include "foreground" and "virtualtext".
        mode = "background",
      },
    },
  },
}
