-- ═══════════════════════════════════════════════════════════
-- NEOVIM OPTIONS - Base configuration
-- ═══════════════════════════════════════════════════════════
--
-- This module defines all core Neovim settings via the vim.opt and vim.g APIs.
-- These options control the editor's appearance, editing behavior, and global defaults.
-- Settings here apply globally unless overridden by filetype-specific autocommands.

local opt = vim.opt -- Shorthand for setting global/window/buffer options
local g = vim.g -- Shorthand for setting global variables (vim.g)

-- ───────────────────────────────────────────────────────────
--  GENERAL APPEARANCE
-- ───────────────────────────────────────────────────────────
-- Controls how the editor looks: line numbers, cursor, colors, and scrolling.

-- Line numbers
opt.number = true -- Show absolute line numbers in the gutter
opt.relativenumber = true -- Show relative line numbers (makes j/k jumps easier to count)
opt.cursorline = true -- Highlight the entire line the cursor is on
opt.signcolumn = "yes" -- Always reserve space for the sign column (LSP, git signs, etc.)
-- Prevents the buffer content from shifting when signs appear

-- Scrolling
opt.scrolloff = 10 -- Always keep at least 10 lines visible above and below the cursor
opt.sidescrolloff = 10 -- Same behavior but applied horizontally for long lines

-- Wrapping (line wrapping)
opt.wrap = true -- Soft-wrap lines that exceed the window width (no horizontal scroll)
opt.linebreak = true -- When wrap is on, break lines at word boundaries, not mid-word

-- Interface
opt.termguicolors = true -- Enable 24-bit RGB color support in the terminal
-- Required for most modern colorschemes to render correctly

-- ───────────────────────────────────────────────────────────
--  EDITING
-- ───────────────────────────────────────────────────────────
-- Controls indentation, search behavior, undo, and file safety options.

-- Indentation
opt.tabstop = 2 -- A <Tab> character visually occupies 2 spaces
opt.shiftwidth = 2 -- >> / << indentation and auto-indent use 2-space steps
opt.expandtab = false -- Keep real tab characters (do not convert to spaces)
opt.smartindent = true -- Automatically add extra indentation for new blocks (C-like syntax)
opt.autoindent = true -- Copy indentation from the previous line when starting a new one

-- Search
opt.ignorecase = true -- Case-insensitive search by default
opt.smartcase = true -- Override ignorecase if the search pattern contains uppercase letters
opt.hlsearch = true -- Highlight all matches of the current search pattern
opt.incsearch = true -- Show matches incrementally as you type the search pattern

-- Completion
opt.completeopt = "menu,menuone,noselect" -- Show completion menu even for a single match;
-- do not auto-select the first item
opt.wildmode = "longest:full,full" -- Command-line tab completion: first expand to
-- longest common match, then cycle through options

-- Editing
opt.undofile = true -- Persist undo history to disk so it survives file closes and restarts
opt.undolevels = 100000 -- Allow up to 100,000 undo steps (effectively unlimited)
opt.swapfile = false -- Disable swap file creation (avoids .swp clutter)
opt.backup = false -- Disable backup file creation (avoids filename~ clutter)

-- File encoding
opt.encoding = "utf-8" -- Internal encoding used by Neovim for strings and buffers
opt.fileencoding = "utf-8" -- Encoding written to disk when saving files

-- ───────────────────────────────────────────────────────────
--  BEHAVIOR
-- ───────────────────────────────────────────────────────────
-- Controls mouse support, clipboard integration, window splitting, and visual aids.

-- Mouse
opt.mouse = "a" -- Enable mouse support in all modes (normal, insert, visual, command)

-- Clipboard (system clipboard)
opt.clipboard = "unnamedplus" -- Sync Neovim's default register with the system clipboard (+)
-- Allows seamless copy/paste between Neovim and other apps

-- Split (window splitting)
opt.splitright = true -- :vsplit opens the new window to the right of the current one
opt.splitbelow = true -- :split opens the new window below the current one

-- Invisible characters
opt.list = true -- Make normally invisible characters visible using listchars below
opt.listchars = {
  tab = "→ ", -- Display tab characters as an arrow followed by a space
  trail = "-", -- Mark trailing whitespace at the end of lines with a dash
  nbsp = "␣", -- Display non-breaking spaces (U+00A0) with a visible symbol
  extends = "⟩", -- Indicate that the line continues beyond the right edge of the window
  precedes = "⟨", -- Indicate that the line continues beyond the left edge of the window
}

-- ───────────────────────────────────────────────────────────
--  GLOBAL SETTINGS
-- ───────────────────────────────────────────────────────────
-- Disables unused language providers to reduce startup time and suppress health warnings.

-- Disable unused providers (speeds up startup)
g.loaded_python3_provider = 0 -- Disable the Python 3 provider (set to 0 to skip loading)
g.loaded_perl_provider = 0 -- Disable the Perl provider
g.loaded_ruby_provider = 0 -- Disable the Ruby provider

-- Format on save - LazyVim already handles this,
-- but can be disabled globally if needed
-- Setting this to false will prevent auto-formatting on every buffer write
g.autoformat = true
