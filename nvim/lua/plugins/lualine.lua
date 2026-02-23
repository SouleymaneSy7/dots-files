-- ═══════════════════════════════════════════════════════════
-- PLUGINS - lualine.nvim (Statusline)
-- ═══════════════════════════════════════════════════════════
--
-- Configures lualine as the statusline with a "bubbles" layout style.
-- Integrates Trouble for LSP document symbols and nvim-web-devicons for file icons.
return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- Required for filetype icons in the statusline

    -- Load after the UI is fully ready to avoid flickering during startup
    event = "VeryLazy",

    -- opts receives the existing LazyVim lualine defaults as (_, opts),
    -- allowing us to extend them rather than replace them entirely.
    opts = function(_, opts)
      -- ─── Trouble Symbol Integration ──────────────────────────
      -- Pulls LSP document symbols (functions, classes, variables, etc.)
      -- from Trouble and renders them in lualine_c as breadcrumb-style context.
      local trouble = require("trouble")
      local symbols = trouble.statusline({
        mode = "lsp_document_symbols", -- Show symbols for the current document
        groups = {},
        title = false, -- Don't prepend a title to the symbol display
        filter = { range = true }, -- Only show symbols relevant to the visible range
        format = "{kind_icon}{symbol.name:Normal}", -- Icon + symbol name with Normal highlight
        -- The following line is needed to fix the background color
        -- Set it to the lualine section you want to use
        hl_group = "lualine_c_normal", -- Match background to lualine_c to avoid color mismatch
      })

      -- Append the Trouble symbol component to the existing lualine_c section
      -- inherited from LazyVim defaults, rather than overwriting it.
      table.insert(opts.sections.lualine_c, {
        symbols.get, -- Function that returns the current symbol string
        cond = symbols.has, -- Only render the component when symbols are available
      })

      return {
        -- ───────────────────────────────────────────────────────
        --  OPTIONS
        -- ───────────────────────────────────────────────────────

        options = {
          theme = "auto", -- Automatically match the active colorscheme
          component_separators = "", -- No separators between components within a section
          section_separators = { left = "", right = "" }, -- Powerline-style bubble separators between sections
        },

        -- ───────────────────────────────────────────────────────
        --  SECTIONS - Bubbles layout
        -- ───────────────────────────────────────────────────────
        -- Lualine divides the statusline into 6 sections per side:
        -- Left:  lualine_a → lualine_b → lualine_c
        -- Right: lualine_x → lualine_y → lualine_z
        sections = {

          -- ─── Left Side ───────────────────────────────────────
          lualine_a = {
            {
              "mode", -- Displays current Vim mode (NORMAL, INSERT, etc.)
              separator = { left = "" }, -- Opening bubble cap on the left edge
              padding = { right = 2, left = 1 },
            },
          },
          lualine_b = {
            "filename", -- Current file name
            {
              "branch", -- Active git branch name
              separator = { left = "" }, -- Bubble separator
              padding = { right = 2, left = 1 },
            },
            {
              "diff", -- Git diff summary (added/modified/removed line counts)
              symbols = {
                added = " ", -- Icon for added lines
                modified = " ", -- Icon for modified lines
                removed = " ", -- Icon for removed lines
              },
              separator = { left = "" },
              padding = { right = 2, left = 1 },
            },
          },
          lualine_c = {
            {
              "filename",
              path = 1, -- 0 = name only, 1 = relative, 2 = absolute
              symbols = {
                modified = " ●", -- Indicator shown when buffer has unsaved changes
                readonly = " ", -- Indicator shown for read-only buffers
                unnamed = "[No Name]", -- Placeholder for unnamed buffers
              },
              separator = { left = "" },
              padding = { right = 2, left = 1 },
            },
          },

          -- ─── Right Side ──────────────────────────────────────
          lualine_x = {
            {
              "encoding", -- File encoding (e.g. utf-8)
              "fileformat", -- Line ending format (unix / dos / mac)
              "diagnostics", -- LSP diagnostic counts per severity level
              sources = { "nvim_lsp" }, -- Pull diagnostic counts from the active LSP client
              symbols = {
                error = " ", -- Error icon
                warn = " ", -- Warning icon
                info = " ", -- Info icon
                hint = " ", -- Hint icon
              },
              padding = { right = 1, left = 2 },
            },
          },
          lualine_y = {
            {
              "filetype", -- Detected filetype with icon (e.g. lua, typescript)
              separator = { left = "" },
              padding = { right = 1, left = 2 },
            },
            {
              "progress", -- Scroll progress through the file as a percentage
              separator = { right = "" },
              padding = { right = 1, left = 2 },
            },
          },
          lualine_z = {
            {
              "location", -- Current cursor position as line:column
              separator = { right = "" }, -- Closing bubble cap on the right edge
              padding = { right = 1, left = 2 },
            },
          },
        },

        -- ───────────────────────────────────────────────────────
        --  INACTIVE SECTIONS
        -- ───────────────────────────────────────────────────────
        -- Defines a minimal statusline for windows that are not currently focused.
        -- Most sections are empty to reduce visual noise in background splits.
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {
            {
              "filename",
              path = 1, -- Show relative path so inactive buffers are still identifiable
            },
          },
          lualine_x = { "location" }, -- Keep location visible even in inactive windows
          lualine_y = {},
          lualine_z = {},
        },

        -- ───────────────────────────────────────────────────────
        --  EXTENSIONS
        -- ───────────────────────────────────────────────────────
        -- Extensions provide custom statusline layouts for specific plugin windows.
        -- Each listed plugin gets a tailored statusline instead of the default one.
        extensions = {
          "neo-tree", -- File explorer panel
          "lazy", -- Plugin manager UI
          "mason", -- LSP/tool installer UI
          "trouble", -- Diagnostics and symbol list panel
        },
      }
    end,
  },
}
