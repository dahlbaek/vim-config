local on_attach = require("base-config").on_attach

require("lspconfig").gopls.setup({
  on_attach = on_attach
})
