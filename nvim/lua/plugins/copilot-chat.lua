-- ═══════════════════════════════════════════════════════════
-- PLUGINS - CopilotChat.nvim (GitHub Copilot Chat)
-- ═══════════════════════════════════════════════════════════
--
-- Integrates GitHub Copilot Chat into Neovim as a floating or split window.
-- Allows asking questions, refactoring code, and running prompt actions
-- directly from the editor using the active buffer as context.

return {
  "CopilotC-Nvim/CopilotChat.nvim",
  branch = "main",

  -- Only load the plugin when the CopilotChat command is explicitly invoked,
  -- avoiding any startup cost when Copilot Chat is not needed.
  cmd = "CopilotChat",

  opts = function()
    -- ─── User Display Name ─────────────────────────────────────
    -- Reads the system username from the environment and capitalizes
    -- the first letter for a polished display in the chat headers.
    local user = vim.env.USER or "User"
    user = user:sub(1, 1):upper() .. user:sub(2)

    return {
      -- Automatically enter insert mode when the chat window is opened,
      -- so the user can start typing their prompt immediately.
      auto_insert_mode = true,

      -- ─── Chat Headers ──────────────────────────────────────
      -- Custom labels displayed above each message in the chat window
      -- to visually distinguish user input, Copilot responses, and tool calls.
      headers = {
        user = "  " .. user .. " ", -- Shown above the user's messages
        assistant = "  Copilot ", -- Shown above Copilot's responses
        tool = "󰊳  Tool ", -- Shown above tool/function call results
      },

      -- ─── Window Layout ─────────────────────────────────────
      -- Sets the chat window to occupy 40% of the total editor width,
      -- leaving enough space for the code buffer alongside it.
      window = {
        width = 0.4,
      },
    }
  end,

  -- ─── Keymaps ───────────────────────────────────────────────
  keys = {
    -- Submit the current prompt in the chat window with <C-s>
    -- (alternative to pressing <CR> directly in the chat buffer).
    {
      "<c-s>",
      "<CR>",
      ft = "copilot-chat",
      desc = "Submit Prompt",
      remap = true,
    },

    -- ─── Group Label ─────────────────────────────────────────
    -- Registers <leader>a as the AI group prefix for which-key display.
    { "<leader>a", "", desc = "+ai", mode = { "n", "x" } },

    -- ─── Toggle Chat Window ───────────────────────────────────
    -- Opens the chat window if closed, or closes it if already open.
    {
      "<leader>aa",
      function()
        return require("CopilotChat").toggle()
      end,
      desc = "Toggle (CopilotChat)",
      mode = { "n", "x" },
    },

    -- ─── Clear Chat History ───────────────────────────────────
    -- Resets the current chat session, clearing all messages and context.
    {
      "<leader>ax",
      function()
        return require("CopilotChat").reset()
      end,
      desc = "Clear (CopilotChat)",
      mode = { "n", "x" },
    },

    -- ─── Quick Chat ───────────────────────────────────────────
    -- Opens a small input prompt to send a one-off question to Copilot
    -- without opening the full chat window. Empty input is ignored.
    {
      "<leader>aq",
      function()
        vim.ui.input({
          prompt = "Quick Chat: ",
        }, function(input)
          if input ~= "" then
            require("CopilotChat").ask(input)
          end
        end)
      end,
      desc = "Quick Chat (CopilotChat)",
      mode = { "n", "x" },
    },

    -- ─── Prompt Actions ───────────────────────────────────────
    -- Opens a picker to select from predefined Copilot prompt templates
    -- (e.g. explain, fix, optimize, document, test generation, etc.).
    {
      "<leader>ap",
      function()
        require("CopilotChat").select_prompt()
      end,
      desc = "Prompt Actions (CopilotChat)",
      mode = { "n", "x" },
    },
  },

  config = function(_, opts)
    local chat = require("CopilotChat")

    -- ─── Chat Buffer Autocommand ──────────────────────────────
    -- Disables line numbers in the copilot-chat buffer since they add
    -- no value in a conversational interface and reduce visual clarity.
    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "copilot-chat",
      callback = function()
        vim.opt_local.relativenumber = false
        vim.opt_local.number = false
      end,
    })

    -- Initialize CopilotChat with the options defined above.
    chat.setup(opts)
  end,
}
