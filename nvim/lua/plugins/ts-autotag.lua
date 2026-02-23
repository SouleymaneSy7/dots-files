-- ═══════════════════════════════════════════════════════════
-- PLUGINS - nvim-ts-autotag (Auto Close & Rename HTML Tags)
-- ═══════════════════════════════════════════════════════════
--
-- Uses Treesitter to automatically close and rename HTML/JSX/XML tags.
-- Works with any filetype that has a Treesitter parser supporting tags
-- (html, tsx, jsx, vue, svelte, php, etc.).

return {
  "windwp/nvim-ts-autotag",

  -- Load when a file is opened; tag auto-closing is only relevant
  -- in the context of an active buffer.
  event = "LazyFile",

  opts = {
    -- Automatically insert the matching closing tag (e.g. </div>)
    -- as soon as the opening tag is completed.
    enable_close = true,

    -- Automatically rename the paired closing tag when the opening
    -- tag is edited, keeping both tags in sync at all times.
    enable_rename = true,

    -- Automatically close the tag when a forward slash is typed
    -- inside an opening tag (e.g. typing <img/ produces <img/>).
    enable_close_on_slash = true,
  },
}
