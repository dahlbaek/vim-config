local on_attach = require("base-config").on_attach

local function set_progress(progress)
  vim.api.nvim_set_var("gopls_progress", progress)
end

local function handle_progress(_, progress, _)
  local val = progress.value
  local kind = val.kind or ""
  if kind == "begin" then
    message = val.message or ""
    set_progress(val.title .. ": " .. message)
  elseif kind == "end" then
    set_progress("")
  end
end

function CustomStatusline()
  progress = vim.g["gopls_progress"] or ""
  return table.concat({
    "%<",
    progress,
    "%=",
    "%t"
  })
end

vim.opt.statusline = "%!luaeval('CustomStatusline()')"

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.window = capabilities.window or {}
capabilities.window.workDoneProgress = true

require("lspconfig").gopls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  handlers = {
    ["$/progress"] = handle_progress,
  },
})
