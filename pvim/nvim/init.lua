local default_on_attach = require("base-config").on_attach

local on_attach = function(client, bufnr)
  default_on_attach(client, bufnr)

  -- Black mapping to override default format mapping
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>fm", "<cmd>%! black -q -<CR>", { noremap = true })
end

require("lspconfig").pyright.setup({
  on_attach = on_attach
})
