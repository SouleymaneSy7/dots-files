-- ═══════════════════════════════════════════════════════════
-- PLUGINS - typescript-tools.nvim (TypeScript Language Server)
-- ═══════════════════════════════════════════════════════════
--
-- A high-performance alternative to the standard tsserver LSP client.
-- Communicates directly with the TypeScript server instead of routing
-- through the LSP protocol layer, which reduces latency and memory usage.
--
-- Extra capabilities over standard tsserver:
--   - Organize imports with a single keymap
--   - Remove all unused imports at once
--   - Add all missing imports automatically
--   - Rename files while updating every import that references them
--   - Fix all auto-fixable diagnostics in the current file
--
-- The server uses the TypeScript version installed in the project
-- (node_modules/.bin/tsserver) or falls back to the global installation.
--
-- Documentation: https://github.com/pmizio/typescript-tools.nvim

return {
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },

    -- Only load for TypeScript and JavaScript files.
    -- Avoids any startup overhead in non-TS/JS projects.
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },

    opts = {
      settings = {
        -- Publish diagnostics only when leaving insert mode, not while typing.
        -- Prevents error indicators from flickering on every keystroke.
        publish_diagnostic_on = "insert_leave",

        -- Surface all possible code actions including import suggestions.
        expose_as_code_action = { "all" },

        -- Automatically close JSX/TSX tags when the opening tag is completed.
        jsx_close_tag = {
          enable = true,
          filetypes = { "javascriptreact", "typescriptreact" },
        },
      },
    },

    keys = {
      -- ─── Import Management ───────────────────────────────────
      {
        "<leader>ci",
        "<cmd>TSToolsOrganizeImports<cr>",
        desc = "Organize imports (TS)",
      },
      {
        "<leader>cu",
        "<cmd>TSToolsRemoveUnusedImports<cr>",
        desc = "Remove unused imports (TS)",
      },
      {
        "<leader>cI",
        "<cmd>TSToolsAddMissingImports<cr>",
        desc = "Add missing imports (TS)",
      },

      -- ─── File Operations ─────────────────────────────────────
      {
        "<leader>cR",
        "<cmd>TSToolsRenameFile<cr>",
        desc = "Rename file and update all imports (TS)",
      },

      -- ─── Diagnostics ─────────────────────────────────────────
      {
        "<leader>cF",
        "<cmd>TSToolsFixAll<cr>",
        desc = "Fix all auto-fixable errors (TS)",
      },
    },
  },
}
