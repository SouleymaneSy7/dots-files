-- ═══════════════════════════════════════════════════════════
-- PLUGINS - vim-visual-multi (Multiple Cursors)
-- ═══════════════════════════════════════════════════════════
--
-- Adds multiple cursor support to Neovim, similar to Ctrl+D in VS Code.
-- Allows simultaneous editing at multiple positions in the buffer.

return {
  {
    "mg979/vim-visual-multi",

    -- ─── Keymaps ───────────────────────────────────────────────
    -- Lazy-loads the plugin only when one of these keys is pressed.
    -- <A-J> adds a cursor on the line below; <A-K> adds one on the line above.
    keys = {
      { "<A-J>", "<Plug>(VM-Add-Cursor-Down)", mode = "n" },
      { "<A-K>", "<Plug>(VM-Add-Cursor-Up)", mode = "n" },
    },

    -- ─── Initialization ────────────────────────────────────────
    -- init runs before the plugin is loaded, which is required for
    -- vim-visual-multi since its global config variables (vim.g.VM_*)
    -- must be set before the plugin initializes its own mappings.
    init = function()
      -- Enable mouse support for adding and removing cursors with clicks.
      vim.g.VM_mouse_mappings = 1

      -- Override default vim-visual-multi keybindings with custom mappings:
      --   <C-d> → Find and select the word under the cursor (VS Code-style Ctrl+D)
      --   <A-J> → Add a new cursor on the line below the current cursor
      --   <A-K> → Add a new cursor on the line above the current cursor
      vim.g.VM_maps = {
        ["Find Under"] = "<C-d>",
        ["Add Cursor Down"] = "<A-J>",
        ["Add Cursor Up"] = "<A-K>",
      }
    end,
  },
}
