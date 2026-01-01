
-------------------------------------------------------------
-- Basic editor improvements
-------------------------------------------------------------
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-------------------------------------------------------------
-- Bootstrap lazy.nvim
-------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-------------------------------------------------------------
-- Plugins
-------------------------------------------------------------
local plugins = {

  -- Icons
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- Bufferline
  {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("bufferline").setup{
        options = {
          numbers = "ordinal",
          close_command = "bdelete %d",
          right_mouse_command = "bdelete %d",
          left_trunc_marker = "<",
          right_trunc_marker = ">",
          max_name_length = 30,
          max_prefix_length = 15,
          tab_size = 21,
          diagnostics = "nvim_lsp",
          show_buffer_close_icons = true,
          show_close_icon = false,
          separator_style = "slant",
        }
      }
    end,
  },

  -- Nvim-tree
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = { width = 30 },
        renderer = {
          icons = { show = { git = true, folder = true, file = true, folder_arrow = true } }
        },
        filters = { dotfiles = false },
      })
    end,
  },

  -- Colorscheme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = { style = "storm" },
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup{
        defaults = { file_ignore_patterns = { "node_modules", ".git", ".venv" } }
      }
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },

  -- LSP
  "neovim/nvim-lspconfig",
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",

  -- Completion
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
}

-------------------------------------------------------------
-- Lazy setup
-------------------------------------------------------------
require("lazy").setup(plugins)

-------------------------------------------------------------
-- Theme setup
-------------------------------------------------------------
require("tokyonight").setup({ style = "storm" })
vim.cmd.colorscheme("tokyonight")

-------------------------------------------------------------
-- Treesitter setup
-------------------------------------------------------------
require("nvim-treesitter.configs").setup({
  ensure_installed = { "python", "javascript" },
  highlight = { enable = true },
  indent = { enable = true },
})

-------------------------------------------------------------
-- Mason + LSP
-------------------------------------------------------------
require("mason").setup()
require("mason-lspconfig").setup({ ensure_installed = { "pyright" } })

-------------------------------------------------------------
-- nvim-cmp
-------------------------------------------------------------
local cmp = require("cmp")
cmp.setup({
  snippet = { expand = function() end },
  mapping = {
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
  })
})

-------------------------------------------------------------
-- Python LSP (vim.lsp.start)
-------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    local pyright_cmd = vim.fn.stdpath("data") .. "/mason/bin/pyright-langserver"
    vim.lsp.start({
      name = "pyright",
      cmd = { pyright_cmd, "--stdio" },
      filetypes = { "python" },
      root_dir = vim.fs.dirname(vim.fs.find(
        { "pyproject.toml", "setup.py", ".git" },
        { upward = true }
      )[1] or vim.loop.cwd()),
      capabilities = require("cmp_nvim_lsp").default_capabilities(),
    })
  end,
})

-------------------------------------------------------------
-- Keymaps
-------------------------------------------------------------
-- LSP
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { silent = true })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { silent = true })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { silent = true })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { silent = true })

-- NvimTree
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { silent = true })
vim.keymap.set("n", "<leader>o", "<cmd>NvimTreeFocus<CR>", { silent = true })

-- Telescope
local builtin = require("telescope.builtin")
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find files" })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Live grep" })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Buffers" })

-- Bufferline
vim.keymap.set("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })

