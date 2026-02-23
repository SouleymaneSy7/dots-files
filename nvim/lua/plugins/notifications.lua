-- ═══════════════════════════════════════════════════════════
-- PLUGINS - noice.nvim & nvim-notify (Notifications & Messages)
-- ═══════════════════════════════════════════════════════════
--
-- Full notification and message system configuration.
-- noice.nvim replaces the default cmdline, messages, and popupmenu
-- with a modern floating UI. nvim-notify handles styled popup notifications
-- with persistence, animations, and interactive dismissal keymaps.

return {
  -- ─────────────────────────────────────────────────────────
  --  NOICE - Modern interface for messages/commands
  -- ─────────────────────────────────────────────────────────
  {
    "folke/noice.nvim",

    -- Load after the UI is ready; noice is not needed during startup.
    event = "VeryLazy",

    -- nui.nvim provides the low-level UI components (popups, splits, layouts)
    -- that noice.nvim uses to render its floating windows.
    -- nvim-notify is used as the notification backend for error/warn messages.
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },

    opts = {
      -- ───────────────────────────────────────────────────────
      -- LSP Configuration (progress messages, hover, signature)
      -- ───────────────────────────────────────────────────────
      lsp = {
        override = {
          -- Route LSP hover and documentation through noice's
          -- markdown renderer instead of the default Neovim handler.
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },

        -- ─── LSP Progress ──────────────────────────────────
        -- Displays LSP indexing/loading progress in the mini view.
        -- Throttled to 30fps to avoid flooding the notification area.
        progress = {
          enabled = true,
          format = "lsp_progress",
          format_done = "lsp_progress_done",
          throttle = 1000 / 30, -- 30 fps
          view = "mini",
        },

        -- ─── Hover Documentation ───────────────────────────
        -- Renders LSP hover documentation in a styled floating window.
        -- silent = false means an error is shown if no hover info is available.
        hover = {
          enabled = true,
          silent = false,
        },

        -- ─── Signature Help ────────────────────────────────
        -- Shows function signature help automatically when typing arguments.
        -- luasnip integration ensures it works correctly inside snippets.
        signature = {
          enabled = true,
          auto_open = {
            enabled = true,
            trigger = true, -- Trigger on '(' character
            luasnip = true, -- Also trigger inside LuaSnip snippet fields
            throttle = 50, -- Minimum ms between signature updates
          },
        },
      },

      -- ───────────────────────────────────────────────────────
      -- Presets
      -- ───────────────────────────────────────────────────────
      -- Presets are opinionated bundles of configuration that enable
      -- common UI patterns with a single boolean toggle.
      presets = {
        bottom_search = true, -- Show search (/ and ?) at the bottom like classic Vim
        command_palette = true, -- Show : cmdline as a centered floating palette
        long_message_to_split = true, -- Redirect messages taller than the screen to a split
        inc_rename = false, -- No special handling for inc-rename.nvim
        lsp_doc_border = true, -- Add a border around LSP hover/signature windows
      },

      -- ───────────────────────────────────────────────────────
      -- ROUTES - Message redirection rules
      -- ───────────────────────────────────────────────────────
      -- Routes allow filtering messages by content or event and
      -- redirecting them to different views or suppressing them entirely.
      -- Rules are evaluated top-to-bottom; first match wins.
      routes = {

        -- ─── Persistent Error/Warning Notifications ─────────
        -- Important messages matching error/warning patterns are sent
        -- to nvim-notify with a 30-second timeout so they are not missed.
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "Error" },
              { find = "error" },
              { find = "warning" },
              { find = "Warning" },
              { find = "E%d+:" }, -- Vim error codes like E123:
            },
          },
          view = "notify",
          opts = {
            timeout = 30000, -- Stay visible for 30 seconds
            replace = false, -- Stack alongside other notifications
            merge = false, -- Never merge with other notifications
          },
        },

        -- ─── Short Success Notifications ────────────────────
        -- Write, save, and yank confirmations are shown briefly
        -- in the non-intrusive mini view at the bottom-right corner.
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "written" },
              { find = "saved" },
              { find = "yanked" },
            },
          },
          view = "mini",
        },

        -- ─── Suppressed Spam Messages ───────────────────────
        -- High-frequency or low-value messages are silently discarded
        -- to keep the notification area clean during normal editing.
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" }, -- "10L, 100B" byte/line count after yank
              { find = "; after #%d+" }, -- Undo/redo position messages
              { find = "; before #%d+" }, -- Undo/redo position messages
              { find = "%d fewer lines" }, -- Line deletion count feedback
              { find = "%d more lines" }, -- Line addition count feedback
              { find = "Already at" }, -- "Already at newest change" undo feedback
              { find = "search hit" }, -- "search hit BOTTOM/TOP" wrap feedback
            },
          },
          opts = { skip = true }, -- Discard silently, show nothing
        },

        -- ─── Long Messages → Split ───────────────────────────
        -- Messages taller than 10 lines are redirected to a split
        -- window so the user can scroll and read them comfortably.
        {
          filter = {
            event = "msg_show",
            min_height = 10,
          },
          view = "split",
        },

        -- ─── Write Confirmation → Mini ───────────────────────
        -- Ensures :write confirmation messages are shown discretely
        -- in the mini view rather than a full notification popup.
        {
          filter = {
            event = "msg_show",
            kind = "",
            find = "written",
          },
          opts = { skip = false },
          view = "mini",
        },
      },

      -- ───────────────────────────────────────────────────────
      -- VIEWS - Configuration for each display surface
      -- ───────────────────────────────────────────────────────

      views = {

        -- ─── Cmdline Popup ───────────────────────────────────
        -- The floating window used for : command-line input.
        -- Centered on screen to function as a command palette.
        cmdline_popup = {
          position = {
            row = "50%", -- Vertically centered
            col = "50%", -- Horizontally centered
          },
          size = {
            width = 60,
            height = "auto",
          },
          border = {
            style = "rounded",
            padding = { 0, 1 },
          },
          win_options = {
            winhighlight = {
              Normal = "Normal",
              FloatBorder = "DiagnosticInfo", -- Teal/blue border matching diagnostic info color
            },
          },
        },

        -- ─── Popupmenu ───────────────────────────────────────
        -- The completion/confirmation dropdown popup window.
        -- Positioned slightly below center to sit under the cmdline popup.
        popupmenu = {
          relative = "editor",
          position = {
            row = "60%",
            col = "50%",
          },
          size = {
            width = 60,
            height = 10,
          },
          border = {
            style = "rounded",
            padding = { 0, 1 },
          },
          win_options = {
            winhighlight = {
              Normal = "Normal",
              FloatBorder = "DiagnosticInfo",
            },
          },
        },

        -- ─── Mini View ───────────────────────────────────────
        -- A small borderless notification anchored to the bottom-right
        -- corner of the screen. Used for low-priority transient messages.
        -- Disappears automatically after 2 seconds.
        mini = {
          position = {
            row = -2, -- 2 lines from the bottom of the screen
            col = "100%", -- Flush against the right edge
          },
          size = {
            width = "auto",
            height = "auto",
          },
          border = {
            style = "none", -- No border for a clean minimal appearance
          },
          timeout = 2000, -- Auto-dismiss after 2 seconds
        },
      },

      -- ───────────────────────────────────────────────────────
      -- CMDLINE - Command line configuration
      -- ───────────────────────────────────────────────────────
      -- Controls how the : command line and search prompts are displayed.
      -- Each format entry defines the icon prefix for that command type.
      cmdline = {
        enabled = true,
        view = "cmdline_popup", -- Use the centered floating popup defined above
        format = {
          cmdline = { icon = ">" }, -- Regular : commands
          search_down = { icon = "🔍⌄" }, -- / forward search
          search_up = { icon = "🔍⌃" }, -- ? backward search
          filter = { icon = "$" }, -- Shell filter commands
          lua = { icon = "☾" }, -- :lua commands
          help = { icon = "?" }, -- :help commands
        },
      },

      -- ───────────────────────────────────────────────────────
      -- MESSAGES - General message routing defaults
      -- ───────────────────────────────────────────────────────
      -- Sets the default views for different categories of Neovim messages
      -- before any route-specific overrides are applied.
      messages = {
        enabled = true,
        view = "notify", -- Default view for general messages
        view_error = "notify", -- Errors always go to the notify popup
        view_warn = "notify", -- Warnings always go to the notify popup
        view_history = "messages", -- :messages history uses the messages view
        view_search = "virtualtext", -- Search count shown inline as virtual text
      },

      -- ───────────────────────────────────────────────────────
      -- POPUPMENU - Completion menu backend
      -- ───────────────────────────────────────────────────────
      -- Uses nui.nvim as the rendering backend for the completion popupmenu,
      -- enabling the styled floating window defined in the views section above.
      popupmenu = {
        enabled = true,
        backend = "nui",
      },

      -- ───────────────────────────────────────────────────────
      -- NOTIFY integration
      -- ───────────────────────────────────────────────────────
      -- Ensures noice routes its notification-level messages through
      -- nvim-notify for consistent styled popup rendering.
      notify = {
        enabled = true,
        view = "notify",
      },
    },

    -- ───────────────────────────────────────────────────────
    -- Keymaps
    -- ───────────────────────────────────────────────────────
    keys = {
      -- Open the full Noice message history list
      {
        "<leader>nm",
        "<cmd>Noice<cr>",
        desc = "📜 Historique messages (Noice)",
      },

      -- Browse notification history via the Noice history command
      {
        "<leader>nn",
        function()
          require("noice").cmd("history")
        end,
        desc = "📋 Historique notifications",
      },

      -- Show only the most recently displayed message
      {
        "<leader>nl",
        function()
          require("noice").cmd("last")
        end,
        desc = "📄 Dernier message",
      },

      -- Dismiss all currently visible notifications immediately
      {
        "<leader>nd",
        function()
          require("noice").cmd("dismiss")
        end,
        desc = "🗑️ Effacer notifications",
      },

      -- Temporarily disable Noice (useful when debugging UI issues)
      {
        "<leader>nD",
        function()
          require("noice").cmd("disable")
        end,
        desc = "🚫 Désactiver Noice",
      },

      -- Re-enable Noice after it has been disabled
      {
        "<leader>nE",
        function()
          require("noice").cmd("enable")
        end,
        desc = "✅ Activer Noice",
      },

      -- Open the Noice message history inside Telescope for fuzzy searching
      {
        "<leader>ns",
        function()
          require("noice").cmd("telescope")
        end,
        desc = "🔭 Messages dans Telescope",
      },

      -- ─── LSP Doc Scroll ──────────────────────────────────
      -- Scroll forward/backward inside a noice LSP hover or signature
      -- window without leaving insert or select mode.
      -- expr = true allows returning a fallback keypress when no doc is open.
      {
        "<c-f>",
        function()
          if not require("noice.lsp").scroll(4) then
            return "<c-f>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll forward (LSP doc)",
        mode = { "i", "n", "s" },
      },
      {
        "<c-b>",
        function()
          if not require("noice.lsp").scroll(-4) then
            return "<c-b>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll backward (LSP doc)",
        mode = { "i", "n", "s" },
      },
    },
  },

  -- ─────────────────────────────────────────────────────────
  -- 🔔 NVIM-NOTIFY - Notification system
  -- ─────────────────────────────────────────────────────────
  {
    "rcarriga/nvim-notify",
    opts = {
      -- ───────────────────────────────────────────────────────
      -- Timeout
      -- ───────────────────────────────────────────────────────
      -- false = notifications persist until manually dismissed.
      -- Set to a number (e.g. 5000) for auto-dismissal after N milliseconds.
      timeout = false,

      -- ───────────────────────────────────────────────────────
      -- Appearance
      -- ───────────────────────────────────────────────────────
      -- Background color used when the terminal lacks true transparency support.
      background_colour = "#000000",

      -- Icons displayed in the notification title bar per severity level.
      icons = {
        ERROR = "",
        WARN = "",
        INFO = "",
        DEBUG = "",
        TRACE = "✎",
      },

      -- ───────────────────────────────────────────────────────
      -- Position
      -- ───────────────────────────────────────────────────────
      -- false = notifications stack upward from the bottom-right corner.
      -- true  = notifications stack downward from the top-right corner.
      top_down = false,

      -- ───────────────────────────────────────────────────────
      -- Animation
      -- ───────────────────────────────────────────────────────
      -- Controls the enter/exit animation style for notification windows.
      -- Options: "fade" | "slide" | "fade_in_slide_out" | "static"
      stages = "fade_in_slide_out",

      -- ───────────────────────────────────────────────────────
      -- Rendering
      -- ───────────────────────────────────────────────────────
      -- Controls the visual layout of each notification window.
      -- Options: "default" | "minimal" | "simple" | "compact"
      render = "default",

      -- Size constraints for notification windows.
      max_width = 50, -- Never wider than 50 columns
      max_height = 10, -- Never taller than 10 rows
      minimum_width = 30, -- Always at least 30 columns wide

      -- ───────────────────────────────────────────────────────
      -- Behavior
      -- ───────────────────────────────────────────────────────
      -- false = new notifications are stacked alongside existing ones.
      -- true  = new notifications replace the previous one in-place.
      replace = false,

      -- false = identical notifications are shown separately.
      -- true  = duplicate notifications are merged into a single popup.
      merge = false,

      -- Minimum severity level that triggers a notification popup.
      -- Messages below this level (e.g. DEBUG when set to INFO) are suppressed.
      level = vim.log.levels.INFO,

      -- ───────────────────────────────────────────────────────
      -- Callbacks
      -- ───────────────────────────────────────────────────────
      -- on_open fires each time a new notification window is created.
      -- Used here to make notifications focusable and add dismiss keymaps.
      on_open = function(win)
        -- Allow the notification window to receive focus when navigated to.
        vim.api.nvim_win_set_config(win, { focusable = true })

        local buf = vim.api.nvim_win_get_buf(win)

        -- Press 'q' inside the notification buffer to dismiss it immediately.
        vim.keymap.set("n", "q", function()
          require("notify").dismiss({ buffer = buf })
        end, { buffer = buf, desc = "Fermer notification" })

        -- Press <Esc> inside the notification buffer to dismiss it immediately.
        vim.keymap.set("n", "<Esc>", function()
          require("notify").dismiss({ buffer = buf })
        end, { buffer = buf, desc = "Fermer notification" })
      end,

      -- on_close fires when a notification window is closed.
      -- Currently unused but available for custom teardown logic.
      on_close = function() end,
    },

    -- ───────────────────────────────────────────────────────
    -- Keymaps for nvim-notify
    -- ───────────────────────────────────────────────────────
    keys = {
      -- Browse the full notification history inside Telescope.
      {
        "<leader>nh",
        function()
          require("telescope").extensions.notify.notify()
        end,
        desc = "📜 Historique notifications (Telescope)",
      },

      -- Immediately dismiss all currently visible notifications,
      -- including any that are pending in the queue.
      {
        "<leader>nc",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "🧹 Effacer toutes notifications",
      },
    },

    -- ───────────────────────────────────────────────────────
    -- Initialization
    -- ───────────────────────────────────────────────────────
    -- Overrides the global vim.notify() function with nvim-notify
    -- so all plugins and user code that call vim.notify() will
    -- automatically use the styled popup renderer.
    init = function()
      vim.notify = require("notify")
    end,
  },

  -- ─────────────────────────────────────────────────────────
  -- 🔭 TELESCOPE EXTENSION - Notification history browser
  -- ─────────────────────────────────────────────────────────
  -- Extends an existing Telescope configuration (if present) to load
  -- the notify and noice extensions, enabling history browsing via Telescope.
  {
    "nvim-telescope/telescope.nvim",
    optional = true, -- Only applied if telescope.nvim is already registered
    opts = function(_, opts)
      if not opts.extensions then
        opts.extensions = {}
      end

      -- Safely load the notify extension only if nvim-notify is available.
      local notify_ok, _ = pcall(require, "notify")
      if notify_ok then
        table.insert(opts.extensions, "notify")
      end

      -- Safely load the noice extension only if noice.nvim is available.
      local noice_ok, _ = pcall(require, "noice")
      if noice_ok then
        table.insert(opts.extensions, "noice")
      end
    end,
  },
}
