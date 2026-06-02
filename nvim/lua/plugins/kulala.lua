-- ═══════════════════════════════════════════════════════════
-- PLUGINS - kulala.nvim (REST Client)
-- ═══════════════════════════════════════════════════════════
--
-- A native REST client for Neovim that works with .http and .rest files.
-- Replaces Postman, Insomnia, or Bruno for API testing without leaving
-- the editor.
--
-- Workflow:
--   1. Create a request.http file anywhere in your project
--   2. Write requests in standard HTTP format:
--        GET https://api.example.com/users
--        Authorization: Bearer {{TOKEN}}
--   3. Press <leader>rr to execute the request under the cursor
--   4. The response appears in a split with syntax highlighting
--
-- Environment variables: create a .env or http-client.env.json at the
-- project root (already excluded from git via .gitignore).
--
-- Requires jq for JSON formatting: sudo pacman -S jq
--
-- Documentation: https://github.com/mistweaverco/kulala.nvim

return {
  "mistweaverco/kulala.nvim",

  -- Only load when a .http or .rest file is opened.
  ft = { "http", "rest" },

  opts = {
    -- ─── Response Display ─────────────────────────────────────
    display_mode = "split", -- "split" or "float"
    split_direction = "horizontal", -- Horizontal panel below the request file

    -- Which part of the response to show first.
    -- "body" | "headers" | "headers_body"
    default_view = "body",

    -- ─── Response Formatting ──────────────────────────────────
    -- Pipe JSON responses through jq for readable indentation.
    -- Requires jq to be installed (sudo pacman -S jq).
    formatters = {
      json = { "jq", "." },
      xml = { "xmllint", "--format", "-" },
    },

    -- ─── Status Icons ─────────────────────────────────────────
    icons = {
      inlay = {
        loading = "󰑮 ",
        done = "󰗡 ",
        error = " ",
      },
    },
  },

  keys = {
    -- Group label (only shown in .http buffers)
    { "<leader>r", nil, desc = "REST (kulala)", ft = "http" },

    -- ─── Execute ─────────────────────────────────────────────
    {
      "<leader>rr",
      function()
        require("kulala").run()
      end,
      ft = "http",
      desc = "Run request under cursor",
    },
    {
      "<leader>ra",
      function()
        require("kulala").run_all()
      end,
      ft = "http",
      desc = "Run all requests in file",
    },

    -- ─── Navigate Between Requests ───────────────────────────
    {
      "]r",
      function()
        require("kulala").jump_next()
      end,
      ft = "http",
      desc = "Next request",
    },
    {
      "[r",
      function()
        require("kulala").jump_prev()
      end,
      ft = "http",
      desc = "Previous request",
    },

    -- ─── Response View ────────────────────────────────────────
    {
      "<leader>rb",
      function()
        require("kulala").toggle_view()
      end,
      ft = "http",
      desc = "Toggle body / headers view",
    },
    {
      "<leader>rc",
      function()
        require("kulala").copy()
      end,
      ft = "http",
      desc = "Copy request as curl command",
    },
  },
}
