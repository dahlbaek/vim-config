local api = vim.api

----------------------------------
-- Options -----------------------
----------------------------------
vim.opt_global.completeopt = { "menu", "menuone", "noinsert", "noselect" }
vim.o.grepprg = "rg --vimgrep --smart-case"

----------------------------------
-- Commands ----------------------
----------------------------------
vim.api.nvim_create_user_command('Rg', 'silent grep! <args> | copen | wincmd p', { nargs = "+" })

----------------------------------
-- Global Mappings ---------------
----------------------------------
vim.g.mapleader = " "
local opts = { noremap = true }
api.nvim_set_keymap("i", "<C-Space>", "<C-X><C-O>", opts)
api.nvim_set_keymap("n", "<leader>d", "<cmd>lua vim.diagnostic.setqflist()<CR><C-w><C-p>", opts)
api.nvim_set_keymap("n", "<C-j>", "<cmd>cnext<CR>zz", opts)
api.nvim_set_keymap("n", "<C-k>", "<cmd>cprevious<CR>zz", opts)

----------------------------------
-- LSP Setup ---------------------
----------------------------------
local on_attach = function(client, bufnr)
  local function map(mode, lhs, rhs)
    api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, { noremap = true })
  end

  -- Omnifunc mapping
  api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Black mapping
  map("n", "<leader>fm", "<cmd>%! black -q -<CR>")

  -- LSP mappings
  map("n", "gD", "<cmd>lua vim.lsp.buf.definition()<CR>")
  map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
  map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR><C-w><C-p>")
  map("n", "gds", "<cmd>lua vim.lsp.buf.document_symbol()<CR>")
  map("n", "gws", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>")
  map("i", "<C-h>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
  map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
end

require("lspconfig").pyright.setup({
  on_attach = on_attach,
  settings = {
    python = {
      analysis = {
        diagnosticMode = "workspace",
        useLibraryCodeForTypes = true
      }
    }
  }
})
