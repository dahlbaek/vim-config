-- inspired by how nvim-metals handles the metals status bar extension
-- https://github.com/scalameta/nvim-metals/blob/9f8272802d35928df6c739f8e06f0e2767ad53a7/lua/metals/status.lua
local function set_status(status)
  vim.api.nvim_set_var("metals_status", status)
end

local function handle_status(_, status, _)
  if status.hide then
    set_status("")
  elseif status.text then
    set_status(status.text)
  end
end

function CustomStatusline()
  status = vim.g["metals_status"] or ""
  return table.concat({
    "%<",
    status,
    "%=",
    "%t"
  })
end

vim.opt.statusline = "%!luaeval('CustomStatusline()')"

local on_attach = require("base-config").on_attach

local root_dir = function()
  return vim.env.HOME .. "/workspace"
end

require("lspconfig").metals.setup({
  handlers = {
    ["metals/status"] = handle_status
  },
  init_options = {
    statusBarProvider = 'on',
    isHttpEnabled = true,
    compilerOptions = {
      snippetAutoIndent = false,
    },
  },
  on_attach = on_attach,
  root_dir = root_dir,
})
