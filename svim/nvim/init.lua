-- Adapted from https://github.com/scalameta/nvim-metals/discussions/39#discussion-82302

local api = vim.api

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  api.nvim_set_keymap(mode, lhs, rhs, options)
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

----------------------------------
-- PLUGINS -----------------------
----------------------------------
require("packer").startup(function(use)
  use "wbthomason/packer.nvim"

  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  use({
    "hrsh7th/nvim-cmp",
    requires = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-vsnip" },
      { "hrsh7th/vim-vsnip" },
    },
  })

  use({
    "scalameta/nvim-metals",
    requires = {
      "nvim-lua/plenary.nvim",
    },
  })
end)

----------------------------------
-- OPTIONS -----------------------
----------------------------------
vim.opt_global.completeopt = { "menu", "menuone", "noinsert", "noselect" }
vim.opt_global.shortmess:remove("F"):append("c")
vim.opt.statusline = "%!luaeval('CustomStatusline()')"
vim.opt.laststatus = 3

-- Metals mappings
commands_opts = { initial_mode = "insert" }
map("n", "<leader>mc", "<cmd>lua require('telescope').extensions.metals.commands(commands_opts)<CR>")

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
map("n", "<leader>sh", [[<cmd>lua vim.lsp.buf.signature_help()<CR>]])
map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
map("n", "<leader>fmt", "<cmd>lua vim.lsp.buf.formatting()<CR>")
map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
map("n", "<leader>d", "<cmd>lua require'telescope.builtin'.diagnostics()<CR>")
map("n", "[c", "<cmd>lua vim.diagnostic.goto_prev { wrap = false }<CR>")
map("n", "]c", "<cmd>lua vim.diagnostic.goto_next { wrap = false }<CR>")


-- completion related settings
local cmp = require("cmp")
cmp.setup({
  sources = {
    { name = "nvim_lsp" },
    { name = "vsnip" },
  },
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<C-B>"] = function()
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end,
  }),
})

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
metals_config = require("metals").bare_config()
metals_config.init_options.statusBarProvider = "on"
local capabilities = vim.lsp.protocol.make_client_capabilities()
metals_config.capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
metals_config.settings = {
  bloopSbtAlreadyInstalled = true,
  showImplicitArguments = true,
  showImplicitConversionsAndClasses = true,
  showInferredType = true,
  excludedPackages = {
    "akka.actor.typed.javadsl",
    "com.github.swagger.akka.javadsl"
  }
}

-- Autocmd that will actually be in charging of starting the whole thing
local nvim_metals_group = api.nvim_create_augroup("nvim-metals", { clear = true })
api.nvim_create_autocmd("FileType", {
  pattern = { "scala", "sbt", "java" },
  callback = function()
    require("metals").initialize_or_attach(metals_config)
  end,
  group = nvim_metals_group,
})

