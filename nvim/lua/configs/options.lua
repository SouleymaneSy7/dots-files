-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local custom_opt = vim.opt

-- Break lines at word boundaries
custom_opt.wrap = true
custom_opt.linebreak = true

-- Apply the same indent of the current line when inserting a new line
custom_opt.autoindent = true

-- File Encoding
custom_opt.encoding = "utf-8"
custom_opt.fileencoding = "utf-8"
