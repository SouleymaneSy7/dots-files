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
    servers = { eslint = {} },

    -- ─── Server Setup Hooks ────────────────────────────────────
    -- The setup table allows overriding the initialization logic
    -- for specific servers after they attach to a buffer.
    setup = {
      eslint = function()
        -- on_attach fires every time any LSP client attaches to a buffer.
        -- We use it to fine-tune formatting responsibilities per client:
        require("lazyvim.util").lsp.on_attach(function(client)
          if client.name == "eslint" then
            -- Explicitly grant ESLint the documentFormatting capability
            -- so it can be used as the formatter (e.g. via :lua vim.lsp.buf.format()).
            client.server_capabilities.documentFormattingProvider = true
          elseif client.name == "tsserver" then
            -- Revoke formatting from tsserver to prevent it from competing
            -- with ESLint when both servers are active in the same buffer.
            -- ESLint is preferred for formatting in JS/TS projects.
            client.server_capabilities.documentFormattingProvider = false
          end
        end)
      end,
    },
  },
}
