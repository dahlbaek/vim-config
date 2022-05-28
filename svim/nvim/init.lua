local on_attach = require("base-config").on_attach

local root_dir = function()
  return vim.env.HOME .. "/workspace"
end

require("lspconfig").metals.setup({
  on_attach = on_attach,
  root_dir = root_dir,
})
