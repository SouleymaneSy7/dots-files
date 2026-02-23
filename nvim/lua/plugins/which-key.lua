-- ═══════════════════════════════════════════════════════════
-- WHICH-KEY - Horizontal layout + Disabled in Visual mode
-- ═══════════════════════════════════════════════════════════
--
-- Configures which-key.nvim to display available keybindings in a
-- horizontal popup at the bottom of the screen. Triggers are restricted
-- to normal mode only to avoid interfering with visual mode operations.

return {
  {
    "folke/which-key.nvim",

    -- Load after the UI is ready; which-key is only needed on keypress,
    -- not during startup.
    event = "VeryLazy",

    opts = function(_, opts)
      -- Delay in milliseconds before the which-key popup appears after
      -- a key is pressed. Keeps the popup from flashing on fast typists.
      opts.delay = 300

      -- Visual style preset for the popup window.
      -- Available options: 'classic' | 'modern' | 'helix'
      opts.preset = "modern"

      -- ───────────────────────────────────────────────────────
      --  NO TRIGGERS IN VISUAL MODE
      -- ───────────────────────────────────────────────────────
      -- Explicitly defines which key prefixes trigger the popup and in
      -- which modes. Visual mode (v) is intentionally omitted from most
      -- triggers to avoid blocking common visual operations like g and z.
      opts.triggers = {
        { "<leader>", mode = { "n", "v" } }, -- Leader available in both normal and visual
        { "g", mode = { "n" } }, -- Goto motions in normal mode only
        { "z", mode = { "n" } }, -- Fold commands in normal mode only
        { "]", mode = { "n" } }, -- Next item navigation in normal mode only
        { "[", mode = { "n" } }, -- Prev item navigation in normal mode only
      }

      -- ───────────────────────────────────────────────────────
      --  HORIZONTAL LAYOUT
      -- ───────────────────────────────────────────────────────
      -- Configures the popup window to appear at the very bottom of the
      -- screen in a wide horizontal layout, similar to a command palette.

      if not opts.win then
        opts.win = {}
      end
      opts.win.no_overlap = true -- Prevent the popup from overlapping buffer content
      opts.win.height = { min = 5, max = 30 } -- Constrain popup height between 5 and 30 rows
      opts.win.row = math.huge -- Push the popup to the very bottom of the screen
      opts.win.border = "rounded" -- Rounded border style for the popup window
      opts.win.padding = { 1, 2 } -- 1 row vertical padding, 2 columns horizontal padding
      opts.win.title = true -- Show the popup title bar
      opts.win.title_pos = "center" -- Center the title text in the title bar

      if not opts.layout then
        opts.layout = {}
      end
      opts.layout.width = { min = 20, max = 50 } -- Each column is between 20 and 50 characters wide
      opts.layout.spacing = 3 -- 3 spaces of padding between columns
      opts.layout.align = "left" -- Left-align key labels within each column
      opts.layout.columns = 6 -- Render 6 columns side by side for a wide layout

      if not opts.icons then
        opts.icons = {}
      end
      opts.icons.breadcrumb = "»" -- Separator shown in the keymap breadcrumb trail
      opts.icons.separator = "➜" -- Separator between the key and its description
      opts.icons.group = "+" -- Prefix icon shown before group names
      opts.icons.ellipsis = "…" -- Shown when a label is truncated due to width constraints

      opts.show_help = true -- Show the help footer line at the bottom of the popup
      opts.show_keys = true -- Show the keys that were pressed to open the popup

      return opts
    end,

    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)

      -- ───────────────────────────────────────────────────────
      --  KEY GROUPS (NORMAL MODE ONLY)
      -- ───────────────────────────────────────────────────────
      -- Registers named groups for leader key prefixes and common motion
      -- prefixes. Groups appear as labelled sections in the which-key popup,
      -- making it easier to discover related keymaps at a glance.
      -- Each entry defines: the prefix, a display name, an icon, and the mode.
      wk.add({
        { "<leader>b", group = "Buffers", icon = "󰓩", mode = "n" }, -- Buffer management
        { "<leader>c", group = "Code", icon = "", mode = "n" }, -- Code actions, LSP commands
        { "<leader>d", group = "Debug", icon = "", mode = "n" }, -- DAP debugger commands
        { "<leader>f", group = "Find", icon = "", mode = "n" }, -- File and text search
        { "<leader>g", group = "Git", icon = "", mode = "n" }, -- Git operations
        { "<leader>gh", group = "Hunks", icon = "", mode = "n" }, -- Git hunk navigation and staging
        { "<leader>l", group = "LSP", icon = "", mode = "n" }, -- LSP actions and info
        { "<leader>n", group = "Notify", icon = "", mode = "n" }, -- Notification management
        { "<leader>q", group = "Quit", icon = "", mode = "n" }, -- Quit / session commands
        { "<leader>s", group = "Search", icon = "", mode = "n" }, -- Search and grep commands
        { "<leader>u", group = "UI", icon = "", mode = "n" }, -- UI toggles (wrap, spell, etc.)
        { "<leader>w", group = "Window", icon = "", mode = "n" }, -- Window/split management
        { "<leader>x", group = "Diag", icon = "", mode = "n" }, -- Diagnostics and Trouble
        { "g", group = "Goto", icon = "󰉿", mode = "n" }, -- Go-to motions (gd, gr, etc.)
        { "gs", group = "Surround", icon = "", mode = "n" }, -- Surround text objects
        { "z", group = "Fold", icon = "", mode = "n" }, -- Fold open/close commands
        { "]", group = "Next", icon = "", mode = "n" }, -- Jump to next item
        { "[", group = "Prev", icon = "", mode = "n" }, -- Jump to previous item
      })

      -- Optional startup notification (currently disabled).
      -- Uncomment to confirm which-key loaded successfully on each launch.
      -- vim.notify("Which-Key: Horizontal + Disabled in Visual ✓", vim.log.levels.INFO, { timeout = 1500 })
    end,

    -- ─── Keymaps ───────────────────────────────────────────────
    -- <leader>? opens the which-key popup scoped to the current buffer's
    -- keymaps only, useful for inspecting buffer-local bindings.
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Keymaps",
        mode = "n",
      },
    },
  },
}
