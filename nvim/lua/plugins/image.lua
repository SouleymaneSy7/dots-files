-- ═══════════════════════════════════════════════════════════
-- PLUGINS - snacks.nvim (Image & SVG Viewer)
-- ═══════════════════════════════════════════════════════════
--
-- Enables the image module bundled with snacks.nvim (already
-- installed via snacks.lua and ui-dashboard.lua). Renders images
-- and SVGs directly inside buffers using the Kitty Graphics
-- Protocol, converting non-PNG formats through ImageMagick first.
--
-- Requirements:
--   - ImageMagick installed system-wide: sudo pacman -S imagemagick
--   - A terminal supporting the Kitty Graphics Protocol
--     (kitty, ghostty; tmux needs `allow-passthrough=on`)
--
-- Usage:
--   :e file.svg                   → open and render an image/SVG directly
--   ![alt](path.png) in markdown  → rendered inline below the link
--   Snacks.image.hover()          → preview the image under the cursor
--   :checkhealth snacks            → diagnose detection issues
--
-- Documentation: https://github.com/folke/snacks.nvim/blob/main/docs/image.md

return {
  "folke/snacks.nvim",
  opts = {
    image = {
      -- Turns on the image viewer module (disabled by default in snacks.nvim).
      enabled = true,

      -- ─── Supported Formats ─────────────────────────────────────
      -- Formats that can be opened and rendered directly as a buffer.
      -- "svg" is appended here since it is not enabled by default;
      -- ImageMagick already ships a "vector" conversion profile for it.
      formats = {
        "png",
        "jpg",
        "jpeg",
        "gif",
        "bmp",
        "webp",
        "tiff",
        "heic",
        "avif",
        "mp4",
        "mov",
        "avi",
        "mkv",
        "webm",
        "pdf",
        "icns",
        "svg",
      },

      -- ─── Inline Document Rendering ─────────────────────────────
      -- Controls how images referenced inside documents (markdown,
      -- html, tsx, css, etc.) are displayed, as opposed to opening
      -- an image file directly.
      doc = {
        enabled = true, -- Render images referenced inside supported document types
        inline = true, -- Render the image inline in the buffer rather than in a float
        float = true, -- Fall back to a floating window if inline isn't supported
        max_width = 80, -- Cap the rendered width in columns
        max_height = 40, -- Cap the rendered height in rows
      },

      -- ─── Conversion ─────────────────────────────────────────────
      -- ImageMagick is used to convert any non-PNG format (including
      -- SVG) to PNG before the terminal can display it.
      convert = {
        notify = true, -- Show a notification if a conversion fails, instead of failing silently
      },
    },
  },
}
