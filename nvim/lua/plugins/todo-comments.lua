-- ═══════════════════════════════════════════════════════════
-- PLUGINS - todo-comments.nvim (TODO Highlight & Search)
-- ═══════════════════════════════════════════════════════════
--
-- Highlights TODO, FIXME, HACK, NOTE, and similar comment keywords
-- with distinct colors and icons. Integrates with Trouble to list all
-- TODOs across the project, and with Telescope for fuzzy search.
--
-- LazyVim already includes this plugin in its default extras.
-- This file overrides the default opts to use Catppuccin Macchiato
-- colors and to configure ripgrep to respect the project's exclusions.
--
-- Keymaps provided by LazyVim (preserved, not redefined here):
--   ]t / [t      Jump to next / previous TODO comment
--   <leader>st   List all TODOs via Telescope
--   <leader>xT   Open TODOs in Trouble
--
-- Documentation: https://github.com/folke/todo-comments.nvim

return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },

  opts = {
    -- ─── Sign Column ──────────────────────────────────────────
    -- Show an icon in the sign column for each TODO line.
    signs = true,
    sign_priority = 8,

    -- ─── Keywords ─────────────────────────────────────────────
    -- Each keyword has a color (Catppuccin Macchiato hex), an icon,
    -- and optional alternate spellings.
    keywords = {
      FIX = {
        icon = " ",
        color = "#ed8796", -- Catppuccin Macchiato red
        alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
      },
      TODO = {
        icon = " ",
        color = "#8aadf4", -- Catppuccin Macchiato blue
      },
      HACK = {
        icon = " ",
        color = "#f5a97f", -- Catppuccin Macchiato peach
        alt = { "TEMP" },
      },
      WARN = {
        icon = " ",
        color = "#eed49f", -- Catppuccin Macchiato yellow
        alt = { "WARNING", "XXX" },
      },
      PERF = {
        icon = "󰅒 ",
        color = "#c6a0f6", -- Catppuccin Macchiato mauve
        alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" },
      },
      NOTE = {
        icon = "󰍨 ",
        color = "#a6da95", -- Catppuccin Macchiato green
        alt = { "INFO" },
      },
      TEST = {
        icon = "󰙨 ",
        color = "#8bd5ca", -- Catppuccin Macchiato teal
        alt = { "TESTING", "PASSED", "FAILED" },
      },
    },

    -- ─── Ripgrep Search ───────────────────────────────────────
    -- Exclude the same directories ignored by snacks.lua and yazi.
    search = {
      command = "rg",
      args = {
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--glob=!node_modules/**",
        "--glob=!dist/**",
        "--glob=!.git/**",
      },
      pattern = [[\b(KEYWORDS):]],
    },
  },
}
