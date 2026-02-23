-- ═══════════════════════════════════════════════════════════
-- BOOTSTRAP - lazy.nvim Plugin Manager Entry Point
-- ═══════════════════════════════════════════════════════════
--
-- This is the main entry point for Neovim's plugin system.
-- It bootstraps lazy.nvim if not already installed, then initializes
-- it with all plugin specs, performance settings, and update behavior.

-- ─── Bootstrap lazy.nvim ───────────────────────────────────
-- Resolves the expected installation path for lazy.nvim using Neovim's
-- standard data directory (typically ~/.local/share/nvim/lazy/lazy.nvim).

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Check if lazy.nvim is already installed by verifying the directory exists.
-- vim.uv is preferred (Neovim 0.10+); vim.loop is the fallback for older versions.
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"

  -- Clone the latest stable branch of lazy.nvim using a blobless clone
  -- (--filter=blob:none) to minimize download size while preserving full history.
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })

  -- If the git clone failed (non-zero shell exit code), display a clear error
  -- message in the Neovim echo area and exit gracefully to avoid a broken state.
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

-- Prepend lazy.nvim's path to the Neovim runtime path so it can be
-- required immediately, before any other plugins are loaded.
vim.opt.rtp:prepend(lazypath)

-- ─── Plugin Setup ──────────────────────────────────────────
-- Initialize lazy.nvim with the full plugin specification and configuration.
require("lazy").setup({

  -- ─── Plugin Specifications ─────────────────────────────────
  -- The spec table defines all plugins to be managed.
  -- Entries are evaluated in order; later entries can override earlier ones.
  spec = {
    -- Load LazyVim's core plugin suite and all its bundled plugin configurations.
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },

    -- Import LazyVim extras for ESLint linting support.
    { import = "lazyvim.plugins.extras.linting.eslint" },

    -- Import LazyVim extras for Prettier formatting support.
    { import = "lazyvim.plugins.extras.formatting.prettier" },

    -- Import all custom user plugins from the lua/plugins/ directory.
    -- Any plugin spec here can override or extend the LazyVim defaults above.
    { import = "plugins" },
  },

  -- ─── Defaults ──────────────────────────────────────────────
  defaults = {
    -- false = only LazyVim's own plugins are lazy-loaded by default.
    -- Custom plugins load eagerly at startup unless they define their own
    -- lazy-loading triggers (event, cmd, keys, ft, etc.).
    lazy = false,

    -- false = always use the latest git commit instead of tagged releases.
    -- Many plugins have outdated or missing semver tags that could cause breakage.
    version = false,
    -- version = "*", -- Uncomment to prefer latest stable semver tag when available
  },

  -- ─── Install ───────────────────────────────────────────────
  -- Fallback colorschemes used during the initial plugin installation screen
  -- before the user's chosen colorscheme plugin has been installed.
  install = { colorscheme = { "tokyonight", "habamax" } },

  -- ─── Update Checker ────────────────────────────────────────
  -- Periodically checks for plugin updates in the background.
  -- notify = false suppresses the update-available notification popup
  -- to avoid interrupting the workflow on every Neovim startup.
  checker = {
    enabled = true, -- Enable automatic background update checks
    notify = false, -- Do not show a notification when updates are available
  },

  -- ─── Performance ───────────────────────────────────────────
  performance = {
    rtp = {
      -- Disable built-in Neovim plugins that are rarely needed.
      -- This reduces startup time by skipping unnecessary plugin loading.
      -- Commented-out entries are disabled by LazyVim but left for reference.
      disabled_plugins = {
        "gzip", -- Editing gzip-compressed files (rarely needed)
        -- "matchit",  -- Extended % matching (replaced by Treesitter)
        -- "matchparen",-- Highlight matching parens (can cause lag on large files)
        -- "netrwPlugin",-- Built-in file browser (replaced by neo-tree/oil)
        "tarPlugin", -- Editing tar archives
        "tohtml", -- Converting buffers to HTML
        "tutor", -- :Tutor interactive tutorial
        "zipPlugin", -- Editing zip archives
      },
    },
  },
})
