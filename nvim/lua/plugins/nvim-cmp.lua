-- ═══════════════════════════════════════════════════════════
-- PLUGINS - nvim-cmp & LuaSnip (Supertab Completion)
-- ═══════════════════════════════════════════════════════════
--
-- Configures nvim-cmp with "supertab" behavior: a single <Tab> key
-- intelligently handles snippet expansion, field jumping, and completion
-- confirmation depending on the current context.

return {

  -- ─── LuaSnip ───────────────────────────────────────────────
  -- Disables LuaSnip's default <Tab>/<S-Tab> keymaps by returning an
  -- empty keys table. This hands full control of Tab behavior over to
  -- the nvim-cmp supertab implementation defined below.
  {
    "L3MON4D3/LuaSnip",
    keys = function()
      return {} -- Clear all default LuaSnip keymaps
    end,
  },

  -- ─── nvim-cmp ──────────────────────────────────────────────
  -- The completion engine. Extended here with emoji source support
  -- and a custom supertab mapping that unifies snippet and completion navigation.
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji", -- Adds emoji completion source (trigger with :)
    },
    opts = function(_, opts)
      -- ─── Helper: has_words_before ───────────────────────────
      -- Returns true if there is at least one non-whitespace character
      -- to the left of the cursor on the current line.
      -- Used to decide whether to open the completion popup on <Tab>.
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local luasnip = require("luasnip")
      local cmp = require("cmp")

      -- Merge the custom Tab mappings into the existing opts.mapping table.
      -- "force" ensures our definitions override any upstream defaults for these keys.
      opts.mapping = vim.tbl_extend("force", opts.mapping, {

        -- ─── <Tab> - Forward Supertab ─────────────────────────
        -- Priority order when <Tab> is pressed in insert or select mode:
        --   1. If inside a LuaSnip snippet → expand or jump to next field
        --   2. If completion menu is visible → confirm the selected item
        --   3. If a native vim.snippet is active → jump forward one field
        --   4. If there are characters before the cursor → open the completion menu
        --   5. Otherwise → fall back to default <Tab> behavior (e.g. insert a tab)
        ["<Tab>"] = cmp.mapping(function(fallback)
          -- If it's a snippet then jump between fields
          if luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          -- otherwise if the completion pop is visible then complete
          elseif cmp.visible() then
            cmp.confirm({ select = true })
          elseif vim.snippet.active({ direction = 1 }) then
            vim.schedule(function()
              vim.snippet.jump(1) -- Jump forward in native snippet
            end)
          -- if the popup is not visible then open the popup
          elseif has_words_before() then
            cmp.complete()
          -- otherwise fallback
          else
            fallback()
          end
        end, { "i", "s" }), -- Active in insert and select modes

        -- ─── <S-Tab> - Backward Supertab ─────────────────────
        -- Priority order when <S-Tab> is pressed in insert or select mode:
        --   1. If completion menu is visible → select the previous item
        --   2. If a native vim.snippet is active → jump backward one field
        --   3. If LuaSnip can jump backward → jump to previous snippet field
        --   4. Otherwise → fall back to default <S-Tab> behavior
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif vim.snippet.active({ direction = -1 }) then
            vim.schedule(function()
              vim.snippet.jump(-1) -- Jump backward in native snippet
            end)
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1) -- Jump backward in LuaSnip snippet
          else
            fallback()
          end
        end, { "i", "s" }), -- Active in insert and select modes
      })
    end,
  },
}
