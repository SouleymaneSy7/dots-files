-- ═══════════════════════════════════════════════════════════
-- PLUGINS - nvim-notify & noice.nvim (Notification System)
-- ═══════════════════════════════════════════════════════════
--
-- Full notification system configuration.
-- nvim-notify handles styled popup notifications with persistence,
-- animations, and interactive dismissal keymaps.
-- The noice.nvim spec here configures only notification-related
-- concerns: routes, message views, and the notify integration.
-- Command-line UI and popup menus live in noice.lua.

return {

  -- ─────────────────────────────────────────────────────────
  -- NOICE - Notification routes & message views
  -- ─────────────────────────────────────────────────────────
  -- LazyVim merges multiple specs for the same plugin, so this
  -- spec coexists with noice.lua without conflict. Only notification-
  -- related options are set here.
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      -- ─── Message defaults ────────────────────────────────────
      -- Sets the default views for different categories of Neovim
      -- messages before any route-specific overrides are applied.
      opts.messages = {
        enabled = true,
        view = "notify", -- Default view for general messages
        view_error = "notify", -- Errors always go to the notify popup
        view_warn = "notify", -- Warnings always go to the notify popup
        view_history = "messages", -- :messages history uses the messages view
        view_search = "virtualtext", -- Search count shown inline as virtual text
      }

      -- ─── Notify integration ──────────────────────────────────
      -- Ensures noice routes its notification-level messages through
      -- nvim-notify for consistent styled popup rendering.
      opts.notify = {
        enabled = true,
        view = "notify",
      }

      -- ─── Routes ──────────────────────────────────────────────
      -- Redirect messages by content or event to specific views,
      -- or suppress them entirely. Rules are evaluated top-to-bottom;
      -- first match wins.
      opts.routes = vim.list_extend(opts.routes or {}, {

        -- ─── Persistent Error/Warning Notifications ───────────
        -- Important messages are sent to nvim-notify with a 30-second
        -- timeout so they are never missed.
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

        -- ─── Short Success Notifications ─────────────────────
        -- Write, save, and yank confirmations are shown briefly in
        -- the non-intrusive mini view at the bottom-right corner.
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

        -- ─── Write Confirmation → Mini ────────────────────────
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

        -- ─── Long Messages → Split ────────────────────────────
        -- Messages taller than 10 lines are redirected to a split
        -- window so the user can scroll and read them comfortably.
        {
          filter = {
            event = "msg_show",
            min_height = 10,
          },
          view = "split",
        },

        -- ─── Suppressed Spam Messages ─────────────────────────
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
      })

      -- ─── Notification views ──────────────────────────────────
      -- Layout for notification-specific surfaces. Popup/cmdline
      -- views are configured in noice.lua.
      opts.views = vim.tbl_deep_extend("force", opts.views or {}, {

        -- ─── Mini View ──────────────────────────────────────
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
      })
    end,

    -- ─── Notification keymaps (noice side) ──────────────────
    keys = {

      -- Browse notification history via the Noice history command.
      {
        "<leader>nn",
        function()
          require("noice").cmd("history")
        end,
        desc = "Notification history (Noice)",
      },

      -- Dismiss all currently visible notifications immediately.
      {
        "<leader>nd",
        function()
          require("noice").cmd("dismiss")
        end,
        desc = "Dismiss notifications",
      },
    },
  },

  -- ─────────────────────────────────────────────────────────
  -- NVIM-NOTIFY - Styled popup notification backend
  -- ─────────────────────────────────────────────────────────
  {
    "rcarriga/nvim-notify",

    opts = {
      -- ─── Position ────────────────────────────────────────
      -- false = notifications stack upward from the bottom-right corner.
      -- true  = notifications stack downward from the top-right corner.
      top_down = false,

      -- ─── Appearance ──────────────────────────────────────
      -- Background color used when the terminal lacks true transparency.
      background_colour = "#000000",

      -- Icons displayed in the notification title bar per severity level.
      icons = {
        ERROR = "",
        WARN = "",
        INFO = "",
        DEBUG = "",
        TRACE = "✎",
      },

      -- ─── Animation ───────────────────────────────────────
      -- Controls the enter/exit animation style for notification windows.
      -- Options: "fade" | "slide" | "fade_in_slide_out" | "static"
      stages = "fade_in_slide_out",

      -- ─── Rendering ───────────────────────────────────────
      -- Controls the visual layout of each notification window.
      -- Options: "default" | "minimal" | "simple" | "compact"
      render = "default",

      -- Size constraints for notification windows.
      max_width = 50, -- Never wider than 50 columns
      max_height = 10, -- Never taller than 10 rows
      minimum_width = 30, -- Always at least 30 columns wide

      -- ─── Timeout ─────────────────────────────────────────
      -- false = notifications persist until manually dismissed.
      -- Set to a number (e.g. 5000) for auto-dismissal after N ms.
      timeout = false,

      -- ─── Behavior ────────────────────────────────────────
      -- false = new notifications are stacked alongside existing ones.
      -- true  = new notifications replace the previous one in-place.
      replace = false,

      -- false = identical notifications are shown separately.
      -- true  = duplicate notifications are merged into a single popup.
      merge = false,

      -- Minimum severity level that triggers a notification popup.
      -- Messages below this level (e.g. DEBUG when set to INFO) are suppressed.
      level = vim.log.levels.INFO,

      -- ─── Callbacks ───────────────────────────────────────
      -- on_open fires each time a new notification window is created.
      -- Used here to make notifications focusable and add dismiss keymaps.
      on_open = function(win)
        -- Allow the notification window to receive focus when navigated to.
        vim.api.nvim_win_set_config(win, { focusable = true })

        local buf = vim.api.nvim_win_get_buf(win)

        -- Press 'q' inside the notification buffer to dismiss it immediately.
        vim.keymap.set("n", "q", function()
          require("notify").dismiss({ buffer = buf } --[[@as any]])
        end, { buffer = buf, desc = "Close notification" })

        -- Press <Esc> inside the notification buffer to dismiss it immediately.
        vim.keymap.set("n", "<Esc>", function()
          require("notify").dismiss({ buffer = buf } --[[@as any]])
        end, { buffer = buf, desc = "Close notification" })
      end,

      -- on_close fires when a notification window is closed.
      -- Currently unused but available for custom teardown logic.
      on_close = function() end,
    },

    -- ─── Keymaps ─────────────────────────────────────────────
    keys = {
      -- Browse the full notification history inside Telescope.
      {
        "<leader>nh",
        function()
          require("telescope").extensions.notify.notify()
        end,
        desc = "Notification history (Telescope)",
      },

      -- Immediately dismiss all currently visible notifications,
      -- including any that are pending in the queue.
      {
        "<leader>nc",
        function()
          require("notify").dismiss({ silent = true, pending = true } --[[@as any]])
        end,
        desc = "Clear all notifications",
      },
    },

    -- ─── Initialization ───────────────────────────────────────
    -- Overrides the global vim.notify() function with nvim-notify
    -- so all plugins and user code that call vim.notify() will
    -- automatically use the styled popup renderer.
    init = function()
      vim.notify = require("notify")
    end,
  },

  -- ─────────────────────────────────────────────────────────
  -- TELESCOPE EXTENSION - Notification history browser
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
