-- ═══════════════════════════════════════════════════════════
-- PLUGINS - nvim-lspconfig (ESLint LSP Configuration)
-- ═══════════════════════════════════════════════════════════
--
-- Configures the ESLint language server via nvim-lspconfig.
-- Ensures ESLint is the designated formatting provider while
-- disabling formatting from tsserver to avoid conflicts.

return {
  "neovim/nvim-lspconfig",
  opts = {
    -- ─── LSP Servers ───────────────────────────────────────────
    -- Register ESLint as an LSP server with default settings.
    -- An empty table {} means no custom server options; LazyVim's
    -- defaults will be used for capabilities, root detection, etc.
    servers = {
      eslint = {
        on_attach = function(client)
          client.server_capabilities.documentFormattingProvider = true
        end,
      },
    },
  },
}
