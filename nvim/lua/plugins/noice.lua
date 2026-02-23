-- ═══════════════════════════════════════════════════════════
-- PLUGINS - nvim-notify & noice.nvim (UI Notifications)
-- ═══════════════════════════════════════════════════════════
--
-- Configures the notification system and the command-line UI.
-- nvim-notify handles popup notifications; noice.nvim replaces the
-- default cmdline, messages, and popupmenu with a modern floating UI.

return {

  -- ─── nvim-notify ───────────────────────────────────────────
  -- Replaces Neovim's default vim.notify() with styled popup notifications.
  {
    "rcarriga/nvim-notify",
    opts = {
      -- Display notifications from the bottom of the screen upward
      -- instead of the default top-down stacking behavior.
      top_down = false,
    },
  },

  -- ─── noice.nvim ────────────────────────────────────────────
  -- Overhauls the Neovim UI by routing cmdline input, messages, and
  -- completion menus through fully customizable floating windows.
  {
    "folke/noice.nvim",

    -- opts receives LazyVim's existing noice defaults as (_, opts),
    -- allowing selective overrides without discarding upstream config.
    opts = function(_, opts)
      -- ─── Command Palette Preset ──────────────────────────────
      -- Customizes the layout of the floating cmdline and popupmenu windows
      -- that appear when the command palette preset is active.
      opts.presets = {
        command_palette = {
          views = {

            -- ─── Cmdline Popup ─────────────────────────────────
            -- The floating window where command-line input is typed.
            -- Centered on screen using percentage-based positioning.
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
            },

            -- ─── Cmdline Popupmenu ─────────────────────────────
            -- The completion dropdown that appears below the cmdline popup.
            -- Positioned slightly lower than the cmdline to simulate
            -- a natural dropdown attached to the input field.
            cmdline_popupmenu = {
              position = {
                row = "67%", -- Placed below the centered cmdline popup
                col = "50%", -- Horizontally centered to align with cmdline
              },
            },

            -- ─── General Popupmenu ─────────────────────────────
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
                style = "rounded", -- Rounded corner border style
                padding = { 0, 1 }, -- No vertical padding, 1 column horizontal padding
              },
              win_options = {
                -- Apply highlight groups to the popup window and its border.
                -- FloatBorder uses NoiceCmdlinePopupBorder for a consistent look.
                winhighlight = { Normal = "Normal", FloatBorder = "NoiceCmdlinePopupBorder" },
              },
            },
          },
        },
      }

      -- ─── LSP Signature Help ──────────────────────────────────
      -- Limits the height of the LSP signature help floating window
      -- to 15 rows, preventing it from taking over the screen on
      -- functions with many overloads or long parameter descriptions.
      opts.lsp.signature = {
        opts = { size = { max_height = 15 } },
      }
    end,
  },
}
