-- ═══════════════════════════════════════════════════════════
-- NEOVIM AUTO-COMMANDS - Automatic actions
-- ═══════════════════════════════════════════════════════════
--
-- This module defines Neovim autocommands organized into logical groups.
-- Autocommands allow Neovim to automatically react to specific events
-- (file open, resize, filetype detection, etc.) without user interaction.

local auto_cmd = vim.api.nvim_create_autocmd -- Shorthand for creating autocommands
local auto_group = vim.api.nvim_create_augroup -- Shorthand for creating autocommand groups (used to avoid duplicate registrations)
local opt_local = vim.opt_local -- Shorthand for setting buffer/window-local options

-- ───────────────────────────────────────────────────────────
--  EDITING HELPERS
-- ───────────────────────────────────────────────────────────
-- Groups autocommands that improve the general editing experience.
-- { clear = true } ensures the group is reset on every config reload,
-- preventing duplicate autocommands from accumulating.
local editing_group = auto_group("EditingHelpers", { clear = true })

-- Return to last cursor position
-- Triggered on 'BufReadPost', which fires after a buffer's content is loaded.
-- Reads the '"' mark (the position where the cursor was when the file was last closed),
-- then restores it if it falls within the current line count.
-- pcall is used to safely attempt the cursor move without throwing errors.
auto_cmd("BufReadPost", {
  group = editing_group,
  pattern = "*",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)

    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,

  desc = "Return to last cursor position",
})

-- ───────────────────────────────────────────────────────────
--  FILE TYPE SPECIFIC SETTINGS
-- ───────────────────────────────────────────────────────────
-- Groups autocommands that apply settings specific to certain file types.
-- These only activate when Neovim detects the relevant filetype.

local filetype_group = auto_group("FileTypeSettings", { clear = true })

-- Markdown: enable wrap and spell check
-- For markdown and plain text files, enables:
--   - 'wrap': soft line wrapping for long lines
--   - 'spell': spell checking
--   - 'spelllang': checks spelling in both French and English
auto_cmd("FileType", {
  group = filetype_group,
  pattern = { "markdown", "text" },

  callback = function()
    opt_local.wrap = true
    opt_local.spell = true
    opt_local.spelllang = "fr,en"
  end,

  desc = "Markdown/Text config",
})

-- JSON: 2-space indentation
-- Overrides the default tab/shift width to 2 spaces for JSON and JSONC files,
-- which is the widely adopted convention for JSON formatting.
auto_cmd("FileType", {
  group = filetype_group,
  pattern = { "json", "jsonc" },

  callback = function()
    opt_local.tabstop = 2
    opt_local.shiftwidth = 2
  end,

  desc = "JSON indentation config",
})

-- YAML: 2-space indentation
-- YAML is indentation-sensitive; 2-space indent is the standard for most YAML schemas
-- (Kubernetes manifests, GitHub Actions, Docker Compose, etc.).
auto_cmd("FileType", {
  group = filetype_group,
  pattern = { "yaml", "yml" },

  callback = function()
    opt_local.tabstop = 2
    opt_local.shiftwidth = 2
  end,

  desc = "YAML indentation config",
})

-- ───────────────────────────────────────────────────────────
--  WINDOWS AND UI
-- ───────────────────────────────────────────────────────────
-- Groups autocommands that manage window layout and UI behavior.

local window_group = auto_group("WindowManagement", { clear = true })

-- Resize splits when Neovim is resized
-- 'VimResized' fires whenever the terminal/GUI window is resized.
-- 'tabdo wincmd =' rebalances all splits across all tabs to equal dimensions.
auto_cmd("VimResized", {
  group = window_group,
  pattern = "*",

  callback = function()
    vim.cmd("tabdo wincmd =")
  end,

  desc = "Resize splits proportionally",
})

-- Close certain window types with 'q'
-- Lists utility/ephemeral window types that don't need to persist.
-- These are typically read-only or informational panels.
local window_pattern = {
  "qf", -- Quickfix list
  "man", -- Man page viewer
  "help", -- Neovim help pages
  "query", -- Treesitter query inspector
  "lspinfo", -- LSP server info panel
  "startuptime", -- Startup time profiler
  "checkhealth", -- :checkhealth output
  "spectre_panel", -- Spectre search/replace panel
}

-- For each of the above filetypes:
--   - Marks the buffer as unlisted (hidden from buffer list)
--   - Maps 'q' in normal mode to ':close', allowing quick dismissal
auto_cmd("FileType", {
  group = window_group,
  pattern = window_pattern,

  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,

  desc = "Close with 'q'",
})

-- ───────────────────────────────────────────────────────────
--  PERFORMANCE
-- ───────────────────────────────────────────────────────────
-- Groups autocommands that safeguard editor performance for edge cases.

local perf_group = auto_group("Performance", { clear = true })

-- Disable certain features for large files
-- 'BufReadPre' fires before the buffer content is fully loaded, making it
-- the ideal moment to check file size and disable expensive features early.
-- Files exceeding 1 MB trigger the following optimizations:
--   - swapfile off     → avoids slow swap writes
--   - foldmethod manual → skips automatic fold computation
--   - undolevels -1    → disables undo history entirely
--   - undoreload 0     → prevents reloading undo history on buffer switch
--   - list off         → hides invisible characters (tabs, trailing spaces)
--   - TSBufDisable     → disables Treesitter syntax highlighting and indentation
--     (both are CPU-intensive on large files)
auto_cmd("BufReadPre", {
  group = perf_group,
  pattern = "*",

  callback = function()
    local max_filesize = 1024 * 1024 -- 1 MB
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(0))

    if ok and stats and stats.size > max_filesize then
      vim.notify("Large file detected, disabling some features", vim.log.levels.WARN)

      -- Disable heavy features
      opt_local.swapfile = false
      opt_local.foldmethod = "manual"
      opt_local.undolevels = -1
      opt_local.undoreload = 0
      opt_local.list = false

      -- Disable treesitter
      vim.cmd("TSBufDisable highlight")
      vim.cmd("TSBufDisable indent")
    end
  end,

  desc = "Optimize for large files",
})

-- ───────────────────────────────────────────────────────────
--  USEFUL NOTIFICATIONS
-- ───────────────────────────────────────────────────────────
-- Groups autocommands that display informational messages to the user.

local notify_group = auto_group("Notifications", { clear = true })

-- Welcome message
-- Fires once on 'VimEnter' (after all plugins and config are loaded).
-- Uses vim.defer_fn with a 100ms delay to ensure the lazy.nvim stats API
-- has fully populated its data before reading it.
-- Displays: total startup time (in ms) and the count of loaded vs total plugins.
auto_cmd("VimEnter", {
  group = notify_group,
  once = true, -- Only fires on the very first VimEnter, not on subsequent tab/session opens

  callback = function()
    -- Wait for everything to be loaded
    vim.defer_fn(function()
      local stats = require("lazy").stats()
      local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)

      vim.notify(
        "⚡ Neovim loaded in " .. ms .. "ms with " .. stats.loaded .. "/" .. stats.count .. " plugins",
        vim.log.levels.INFO,
        { title = "LazyVim" }
      )
    end, 100)
  end,

  desc = "Welcome message",
})
