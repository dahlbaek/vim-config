-- inspired by how nvim-metals handles the metals status bar extension
-- https://github.com/scalameta/nvim-metals/blob/9f8272802d35928df6c739f8e06f0e2767ad53a7/lua/metals/status.lua
local function set_progress(progress)
  vim.api.nvim_set_var("rls_progress", progress)
end

local function handle_progress(_, progress, _)
  if progress.done then
    set_progress("")
  else
    message = progress.title
    if progress.message then
      message = message .. ": " .. progress.message
    end
    if progress.percentage then
      message = message .. ": " .. progress.percentage .. "%"
    end
    set_progress(message)
  end
end

function CustomStatusline()
  progress = vim.g["rls_progress"] or ""
  return table.concat({
    "%<",
    progress,
    "%=",
    "%t"
  })
end

vim.opt.statusline = "%!luaeval('CustomStatusline()')"

local on_attach = require("base-config").on_attach

require("lspconfig").rls.setup({
  on_attach = on_attach,
  handlers = {
    ["window/progress"] = handle_progress,
  },
})
