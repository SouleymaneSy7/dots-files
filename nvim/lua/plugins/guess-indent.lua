-- ═══════════════════════════════════════════════════════════
-- PLUGINS - guess-indent.nvim (Automatic Indentation Detection)
-- ═══════════════════════════════════════════════════════════
--
-- Automatically detects and applies the indentation style (tabs vs spaces
-- and indent width) of any file opened in Neovim, based on its content.

return {
  "nmac427/guess-indent.nvim",
  opts = {
    -- Automatically run indent detection via an autocommand whenever
    -- a buffer is opened or read, without requiring manual invocation.
    auto_cmd = true,

    -- When true, the detected indentation overrides any settings defined
    -- in an .editorconfig file, giving priority to the file's actual content
    -- over project-level configuration.
    override_editorconfig = true,
  },
}
