local saga_status, saga = pcall(require, "lspsaga")
if not saga_status then
  return
end

saga.setup({
  ui = {
    -- kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind(),
  },
  move_in_saga = { prev = "<C-k>", next = "<C-j>" },
  -- symbol_in_winbar = { enable = false },
  finder_action_keys = {
    open = "<CR>",
  },
  definition_action_keys = {
    edit = "<CR>",
  },
})
