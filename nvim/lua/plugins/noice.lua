-- ═══════════════════════════════════════════════════════════
-- PLUGINS - noice.nvim (Command-line & Popup UI)
-- ═══════════════════════════════════════════════════════════
--
-- Configures the command-line and popup menu UI surfaces only.
-- Notification routing and nvim-notify setup live in notifications.lua.
-- noice.nvim replaces the default cmdline, popupmenu, and LSP floating
-- windows with a modern, fully customizable floating UI.

return {
  {
    "folke/noice.nvim",

    -- opts receives LazyVim's existing noice defaults as (_, opts),
    -- allowing selective overrides without discarding upstream config.
    opts = function(_, opts)
      -- ─── Presets ──────────────────────────────────────────────
      -- Opinionated bundles that enable common UI patterns with a
      -- single boolean toggle.
      opts.presets = {
        bottom_search = true, -- Show search (/ and ?) at the bottom like classic Vim
        command_palette = true, -- Show : cmdline as a centered floating palette
        long_message_to_split = true, -- Redirect tall messages to a split window
        inc_rename = false, -- No special handling for inc-rename.nvim
        lsp_doc_border = true, -- Add a border around LSP hover/signature windows
      }

      -- ─── Cmdline ──────────────────────────────────────────────
      -- Controls how the : command line and search prompts are displayed.
      -- Each format entry defines the icon prefix for that command type.
      opts.cmdline = {
        enabled = true,
        view = "cmdline_popup", -- Use the centered floating popup defined in views
        format = {
          cmdline = { icon = ">" }, -- Regular : commands
          search_down = { icon = "🔍⌄" }, -- / forward search
          search_up = { icon = "🔍⌃" }, -- ? backward search
          filter = { icon = "$" }, -- Shell filter commands
          lua = { icon = "☾" }, -- :lua commands
          help = { icon = "?" }, -- :help commands
        },
      }

      -- ─── Popupmenu ────────────────────────────────────────────
      -- Uses nui.nvim as the rendering backend for the completion
      -- popupmenu, enabling the styled floating window defined below.
      opts.popupmenu = {
        enabled = true,
        backend = "nui",
      }

      -- ─── LSP ──────────────────────────────────────────────────
      opts.lsp = {
        override = {
          -- Route LSP hover and documentation through noice's markdown
          -- renderer instead of the default Neovim handler.
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },

        -- ─── LSP Progress ────────────────────────────────────
        -- Displays LSP indexing/loading progress in the mini view.
        -- Throttled to 30fps to avoid flooding the notification area.
        progress = {
          enabled = true,
          format = "lsp_progress",
          format_done = "lsp_progress_done",
          throttle = 1000 / 30, -- 30 fps
          view = "mini",
        },

        -- ─── Hover Documentation ─────────────────────────────
        -- Renders LSP hover documentation in a styled floating window.
        -- silent = false means an error is shown if no hover info is available.
        hover = {
          enabled = true,
          silent = false,
        },

        -- ─── Signature Help ──────────────────────────────────
        -- Shows function signature help automatically when typing arguments.
        -- Capped at 15 rows to avoid taking over the screen on functions
        -- with many overloads or long parameter descriptions.
        signature = {
          enabled = true,
          auto_open = {
            enabled = true,
            trigger = true, -- Trigger on '(' character
            luasnip = true, -- Also trigger inside LuaSnip snippet fields
            throttle = 50, -- Minimum ms between signature updates
          },
          opts = {
            size = { max_height = 15 },
          },
        },
      }

      -- ─── Views ────────────────────────────────────────────────
      -- Layout configuration for the cmdline popup and popupmenu
      -- floating windows. Notification-related views (mini, notify)
      -- are configured in notifications.lua.
      opts.views = vim.tbl_deep_extend("force", opts.views or {}, {

        -- ─── Cmdline Popup ─────────────────────────────────────
        -- The floating window where command-line input is typed.
        -- Centered on screen to function as a command palette.
        cmdline_popup = {
          position = {
            row = "50%", -- Vertically centered
            col = "50%", -- Horizontally centered
          },
          size = {
            min_width = 60, -- Never shrink below 60 columns wide
            width = "auto", -- Expand to fit content horizontally
            height = "auto", -- Expand to fit content vertically
          },
          border = {
            style = "rounded",
            padding = { 0, 1 },
          },
          win_options = {
            winhighlight = {
              Normal = "Normal",
              FloatBorder = "DiagnosticInfo", -- Teal/blue border
            },
          },
        },

        -- ─── Cmdline Popupmenu ─────────────────────────────────
        -- The completion dropdown that appears below the cmdline popup.
        -- Positioned slightly lower than the cmdline to simulate a
        -- natural dropdown attached to the input field.
        cmdline_popupmenu = {
          position = {
            row = "67%", -- Placed below the centered cmdline popup
            col = "50%", -- Horizontally centered to align with cmdline
          },
        },

        -- ─── General Popupmenu ─────────────────────────────────
        -- The completion menu used outside of cmdline context
        -- (e.g. insert mode completions). Anchored to a fixed
        -- row position relative to the editor.
        popupmenu = {
          relative = "editor", -- Position relative to the full editor window
          position = {
            row = 23, -- Fixed row from the top of the editor
            col = "50%", -- Horizontally centered
          },
          size = {
            width = 60, -- Fixed width of 60 columns
            height = "auto", -- Expand vertically to fit items
            max_height = 15, -- Cap at 15 rows to avoid overflowing the screen
          },
          border = {
            style = "rounded",
            padding = { 0, 1 },
          },
          win_options = {
            winhighlight = {
              Normal = "Normal",
              FloatBorder = "NoiceCmdlinePopupBorder",
            },
          },
        },
      })
    end,

    -- ─── Keymaps ──────────────────────────────────────────────
    -- Only LSP doc scroll keymaps live here. Notification-related
    -- keymaps (history, dismiss, etc.) live in notifications.lua.
    keys = {

      -- ─── Noice UI Keymaps ─────────────────────────────────
      -- Open the full Noice message history list.
      {
        "<leader>nm",
        "<cmd>Noice<cr>",
        desc = "Message history (Noice)",
      },

      -- Show only the most recently displayed message.
      {
        "<leader>nl",
        function()
          require("noice").cmd("last")
        end,
        desc = "Last message",
      },

      -- Open the Noice message history inside Telescope for fuzzy searching.
      {
        "<leader>ns",
        function()
          require("noice").cmd("telescope")
        end,
        desc = "Messages in Telescope",
      },

      -- Temporarily disable Noice (useful when debugging UI issues).
      {
        "<leader>nD",
        function()
          require("noice").cmd("disable")
        end,
        desc = "Disable Noice",
      },

      -- Re-enable Noice after it has been disabled.
      {
        "<leader>nE",
        function()
          require("noice").cmd("enable")
        end,
        desc = "Enable Noice",
      },

      -- ─── LSP Doc Scroll ───────────────────────────────────
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
}
