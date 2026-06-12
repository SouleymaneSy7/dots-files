-- ═══════════════════════════════════════════════════════════
-- TABBY - Modern Tabline with Catppuccin Macchiato
-- ═══════════════════════════════════════════════════════════
--
-- Replaces the default Neovim tabline with a styled tab bar
-- showing tab numbers, names, and modified indicators.
-- Uses the "tabs_with_wins" preset for a clean workspace layout.

return {
  "nanozuki/tabby.nvim",
  recommended = true,
  desc = "Modern tabline with Catppuccin accents",

  event = "VeryLazy",

  opts = {
    nerdfont = true,
    exclude = { "neo-tree", "Trouble", "help", "qf", "noice", "lazy", "mason" },
  },

  config = function(_, opts)
    local tabby = require("tabby")

    -- ─── Catppuccin Macchiato Highlight Groups ──────────────

    vim.api.nvim_set_hl(0, "TabLine", {
      bg = "#363a4f",
      fg = "#a5adcb",
    })

    vim.api.nvim_set_hl(0, "TabLineSel", {
      bg = "#c6a0f6",
      fg = "#24273a",
      bold = true,
    })

    vim.api.nvim_set_hl(0, "TabLineFill", {
      bg = "#1e2030",
      fg = "#cad3f5",
    })

    tabby.setup(vim.tbl_deep_extend("force", opts, {
      tabline = require("tabby.tabline").use_preset("tabs_with_wins", {
        -- ─── Icons ─────────────────────────────────────────
        icons = {
          modified_indicator = " ●",
          close_icon = " 󰅙",
          separator = " ",
        },

        -- ─── Tab Label ─────────────────────────────────────
        -- label = " {tab.nr}:{tab.name}"  (e.g. " 1:README.md")
        -- tab.nr = tab number (1-based)
        -- tab.name = first buffer name in the tab
        -- Can be a string template or a function

        -- ─── Active Tab Styling ────────────────────────────
        -- Override the active tab's first/last separators
        -- to create a "pill" shape using Unicode triangles
        --  (left-fill) and  (right-fill).
        active_tab = function(tab)
          local label = " " .. tab.nr() .. ":" .. tab.name()
          if tab.is_modified() then
            label = label .. " ●"
          end

          return {
            label = label,
            left_sep = "",
            right_sep = "",
          }
        end,

        -- ─── Inactive Tab Styling ──────────────────────────
        inactive_tab = function(tab)
          local label = " " .. tab.nr() .. ":" .. tab.name()
          if tab.is_modified() then
            label = label .. " ●"
          end

          return {
            label = label,
            left_sep = "",
            right_sep = "",
          }
        end,
      }),
    }))
  end,
}
