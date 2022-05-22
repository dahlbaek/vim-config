local api = vim.api

----------------------------------
-- Options -----------------------
----------------------------------
vim.opt_global.completeopt = { "menu", "menuone", "noinsert", "noselect" }

----------------------------------
-- Global Mappings ---------------
----------------------------------
vim.g.mapleader = " "
local opts = { noremap = true }
api.nvim_set_keymap("i", "<C-Space>", "<C-X><C-O>", opts)
api.nvim_set_keymap("n", "[c", "<cmd>lua vim.diagnostic.goto_prev<CR>", opts)
api.nvim_set_keymap("n", "]c", "<cmd>lua vim.diagnostic.goto_next<CR>", opts)

----------------------------------
-- Telescope Setup ---------------
----------------------------------
require('telescope').setup{
  defaults = {
    -- Default configuration for telescope goes here:
    -- config_key = value,
    mappings = {
      i = {
        -- map actions.which_key to <C-h> (default: <C-/>)
        -- actions.which_key shows the mappings for your picker,
        -- e.g. git_{create, delete, ...}_branch for the git_branches picker
        ["<C-h>"] = "which_key"
      }
    },
    initial_mode = "normal",
  },
  pickers = {
    find_files = {
      initial_mode = "insert"
    },
    live_grep = {
      initial_mode = "insert"
    },
    lsp_dynamic_workspace_symbols = {
      initial_mode = "insert"
    },
  },
}

----------------------------------
-- LSP Setup ---------------------
----------------------------------
local on_attach = function(client, bufnr)
  local function map(mode, lhs, rhs)
    api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, { noremap = true })
  end

  -- Omnifunc mapping
  api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Telescope mappings
  map("n", "<leader>ff", "<cmd>lua require'telescope.builtin'.find_files()<CR>")
  map("n", "<leader>rg", "<cmd>lua require'telescope.builtin'.live_grep()<CR>")

  -- LSP mappings
  map("n", "gD", "<cmd>lua require'telescope.builtin'.lsp_definitions()<CR>")
  map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
  map("n", "gi", "<cmd>lua require'telescope.builtin'.lsp_implementations()<CR>")
  map("n", "gr", "<cmd>lua require'telescope.builtin'.lsp_references()<CR>")
  map("n", "gds", "<cmd>lua require'telescope.builtin'.lsp_document_symbols()<CR>")
  map("n", "gws", "<cmd>lua require'telescope.builtin'.lsp_dynamic_workspace_symbols()<CR>")
  map("i", "<C-h>", [[<cmd>lua vim.lsp.buf.signature_help()<CR>]])
  map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
  map("n", "<leader>fm", "<cmd>lua vim.lsp.buf.formatting()<CR>")
  map("n", "<leader>a", "<cmd>lua vim.lsp.buf.code_action()<CR>")
  map("n", "<leader>d", "<cmd>lua require'telescope.builtin'.diagnostics()<CR>")
end

require("lspconfig").metals.setup({
  on_attach = on_attach,
})
