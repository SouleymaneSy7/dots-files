-- ═══════════════════════════════════════════════════════════
-- PLUGINS - nvim-surround (Surround Text Objects)
-- ═══════════════════════════════════════════════════════════
--
-- Add, change, and delete surrounding pairs with full dot-repeat,
-- visual mode support, and HTML tag awareness.
-- Replaces LazyVim's default mini.surround (disabled below).
--
-- Core operations:
--   ys{motion}{char}  → add surround       e.g. ysiw"  → "word"
--   yss{char}         → surround whole line e.g. yss)  → (the line)
--   cs{old}{new}      → change surround     e.g. cs"'  → 'word'
--   ds{char}          → delete surround     e.g. ds"   →  word
--   S{char}           → surround in visual  e.g. VS<div> → <div>line</div>
--
-- Aliases (single-char shortcuts):
--   a → >    b → )    B → }    r → ]    q → any quote

return {
  -- ─── Disable mini.surround ─────────────────────────────────
  -- LazyVim ships mini.surround by default. Disabling it prevents
  -- duplicate keymaps and operator conflicts with nvim-surround.
  {
    "echasnovski/mini.surround",
    enabled = false,
  },

  -- ─── nvim-surround ─────────────────────────────────────────
  {
    "kylechui/nvim-surround",
    version = "*", -- Follow stable semver tags
    event = "LazyFile",

    opts = {
      -- ─── Keymaps ───────────────────────────────────────────────
      -- Using the classic vim-surround (tpope) naming convention.
      -- These are all buffer-local operators; they do not conflict with
      -- global leader mappings.
      keymaps = {
        insert = "<C-g>s", -- Add surround in insert mode
        insert_line = "<C-g>S", -- Add surround on its own line (insert)
        normal = "ys", -- Add surround
        normal_cur = "yss", -- Surround current line
        normal_line = "yS", -- Add surround on its own line
        normal_cur_line = "ySS", -- Surround current line, on its own line
        visual = "S", -- Add surround in visual mode
        visual_line = "gS", -- Surround on its own line in visual
        delete = "ds", -- Delete surround
        change = "cs", -- Change surround
        change_line = "cS", -- Change surround, place on own line
      },

      -- ─── Aliases ─────────────────────────────────────────────
      -- Convenient single-character shortcuts for common pairs.
      aliases = {
        ["a"] = ">", -- angle bracket: ysla → <word>
        ["b"] = ")", -- bracket:       yslb → (word)
        ["B"] = "}", -- brace:         yslB → {word}
        ["r"] = "]", -- rect bracket:  yslr → [word]
        ["q"] = { '"', "'", "`" }, -- any quote type (cs q" cycles through them)
      },

      -- ─── Highlight ───────────────────────────────────────────
      -- Flash the targeted text region for 150 ms after each surround
      -- operation so you can confirm the correct range was selected.
      highlight = { duration = 150 },

      -- ─── Cursor Position After Add ───────────────────────────
      -- Leave the cursor at the opening pair after adding a surround.
      -- "begin" is useful for then immediately typing inside the pair.
      move_cursor = "begin",
    },
  },
}
