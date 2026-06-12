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
-- Keymaps:
--   ]t / [t          Jump to next / previous TODO comment
--   <leader>st       List all TODOs via Telescope
--   <leader>xT       Open TODOs in Trouble
--   <leader>fT       Browse only TODO + FIXME in Telescope (added)
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

    -- Merge with any keywords LazyVim itself registers rather than replacing them.
    merge_keywords = true,

    -- ─── Highlight ────────────────────────────────────────────
    highlight = {
      multiline = true, -- Follow TODO comments that span multiple lines
      multiline_pattern = "^.", -- A continuing line starts with anything
      multiline_context = 10, -- Look ahead up to 10 lines for context
      before = "", -- No extra highlight before the keyword token
      keyword = "wide_bg", -- Default keyword highlight style
      after = "fg", -- Highlight the rest of the comment text
      pattern = [[.*<(KEYWORDS)\s*:]], -- Match keyword followed by colon
      comments_only = true, -- Only match inside comment syntax nodes
      max_line_len = 400, -- Skip extremely long lines
      exclude = {}, -- No file patterns to exclude
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

  -- ─── Keymaps ──────────────────────────────────────────────
  keys = {
    {
      "]t",
      function()
        require("todo-comments").jump_next()
      end,
      desc = "Next TODO",
    },
    {
      "[t",
      function()
        require("todo-comments").jump_prev()
      end,
      desc = "Prev TODO",
    },
    { "<leader>xT", "<cmd>TodoTrouble<cr>", desc = "TODOs (Trouble)" },
    { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "TODOs (Telescope)" },
    {
      "<leader>fT",
      "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>",
      desc = "TODO + FIXME (Telescope)",
    },
  },
}
