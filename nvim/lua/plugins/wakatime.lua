-- ═══════════════════════════════════════════════════════════
-- PLUGINS - vim-wakatime (Coding Activity Tracker)
-- ═══════════════════════════════════════════════════════════
--
-- Integrates WakaTime into Neovim to automatically track coding activity.
-- Sends metrics (time spent per file, language, and project) to the
-- WakaTime dashboard at wakatime.com in the background.

return {
  {
    "wakatime/vim-wakatime",

    -- Must be loaded eagerly at startup (not deferred) to ensure
    -- tracking begins immediately from the first file opened,
    -- without missing any early coding activity.
    lazy = false,
  },
}
