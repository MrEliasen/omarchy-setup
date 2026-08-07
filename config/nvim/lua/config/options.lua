-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
require("config.remote_clipboard").setup()
vim.g.lazyvim_picker = "telescope"
vim.g.lazyvim_cmp = "nvim-cmp"
vim.g.lazyvim_php_lsp = "intelephense"
vim.opt.autoindent = true
vim.opt.backup = false
vim.opt.cmdheight = 1
vim.opt.completeopt = { "menuone", "noselect" }
vim.opt.conceallevel = 0
vim.opt.cursorline = true
vim.opt.colorcolumn = "100"
vim.opt.expandtab = true
vim.opt.fileencoding = "utf-8"
vim.opt.guicursor = ""
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.laststatus = 3
vim.opt.number = true
vim.opt.numberwidth = 4
vim.opt.pumheight = 10
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.shiftwidth = 4
vim.opt.showmode = false
vim.opt.showtabline = 4
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.spelllang = "en_gb"
vim.opt.swapfile = false
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.updatetime = 50
vim.opt.timeoutlen = 100
vim.opt.wrap = false
vim.opt.writebackup = false
vim.opt.hidden = true
vim.opt.mouse = ""
