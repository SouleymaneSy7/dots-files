-- ═══════════════════════════════════════════════════════════
-- PLUGINS - snacks.nvim (Dashboard Configuration)
-- ═══════════════════════════════════════════════════════════
--
-- Configures the snacks.nvim dashboard with a custom ASCII art header
-- and integrates LazyVim's picker as the default file/command picker.

-- ─── ASCII Art Header ──────────────────────────────────────
-- Multi-line string containing the ASCII art displayed at the top
-- of the dashboard when Neovim is launched without a file argument.
-- Rendered using box-drawing characters for a bold, styled appearance.
local header = [[
██╗  ██╗██████╗  █████╗ ████████╗ ██████╗ ███████╗
██║ ██╔╝██╔══██╗██╔══██╗╚══██╔══╝██╔═══██╗██╔════╝
█████╔╝ ██████╔╝███████║   ██║   ██║   ██║███████╗
██╔═██╗ ██╔══██╗██╔══██║   ██║   ██║   ██║╚════██║
██║  ██╗██║  ██║██║  ██║   ██║   ╚██████╔╝███████║
╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝    ╚═════╝ ╚══════╝
 ]]

return {
  "snacks.nvim",
  opts = {
    dashboard = {
      preset = {
        -- ─── Custom Picker ───────────────────────────────────
        -- Overrides the default dashboard picker with LazyVim's
        -- unified picker (snacks picker / telescope depending on config).
        -- 'cmd' is the picker command (e.g. "files", "oldfiles")
        -- and 'opts' are forwarded as picker options.
        pick = function(cmd, opts)
          return LazyVim.pick(cmd, opts)()
        end,

        -- ─── Header ──────────────────────────────────────────
        -- Assigns the ASCII art defined above as the dashboard header.
        -- Displayed centered at the top of the dashboard on startup.
        header = header,
      },
    },
  },
}
