-- ═══════════════════════════════════════════════════════════
-- PLUGINS - indent-blankline.nvim (Indentation Guides)
-- ═══════════════════════════════════════════════════════════
--
-- Renders vertical guide lines at each indentation level, making
-- nested code structure immediately visible. LazyVim includes ibl
-- by default; this file customises the char, scope indicators,
-- and the list of filetypes that should show no guides.

return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl", -- The module entrypoint changed from 'indent_blankline' to 'ibl' in v3

  opts = {
    -- ─── Indent Character ──────────────────────────────────────
    indent = {
      -- Use a thin vertical bar for indent guides.
      -- Alternatives: "▏" (narrower) | "┆" | "┊" (dashed)
      char = "│",
      tab_char = "│",

      -- Highlight group applied to the indent character.
      -- 'IblIndent' is ibl's own group; link it to a dimmer color if needed.
      highlight = { "IblIndent" },
    },

    -- ─── Scope Highlighting ────────────────────────────────────
    -- The 'scope' underlines the indent guides that belong to the
    -- Treesitter node the cursor is currently inside, visually showing
    -- the active code block. Start/end markers are disabled to keep
    -- the display minimal.
    scope = {
      enabled = true,
      show_start = false, -- No underline at the opening bracket line
      show_end = false, -- No underline at the closing bracket line
      highlight = { "IblScope" },
    },

    -- ─── Excluded Filetypes ────────────────────────────────────
    -- Indent guides are distracting or meaningless in these special buffers.
    exclude = {
      filetypes = {
        "help",
        "alpha",
        "dashboard",
        "neo-tree",
        "Trouble",
        "trouble",
        "lazy",
        "mason",
        "notify",
        "oil", -- oil.nvim file manager
        "toggleterm",
        "lazyterm",
        "TelescopePrompt",
        "TelescopeResults",
      },
      buftypes = {
        "terminal",
        "nofile",
        "quickfix",
        "prompt",
      },
    },
  },
}
