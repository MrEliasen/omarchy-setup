-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local opts = { noremap = true, silent = true }
local normp = { noremap = true }
local map = vim.keymap.set

-- Leader key
map("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Stay in indent mode
map("v", "<", "<gv", normp)
map("v", ">", ">gv", normp)

-- Move text up and down
map("v", "<A-j>", ":m .+1<CR>==", opts)
map("v", "<A-k>", ":m .-2<CR>==", opts)
map("v", "J", ":m '>+1<CR>gv=gv", opts)
map("v", "K", ":m '<-2<CR>gv=gv", opts)

-- Navigate buffers
map("n", "<S-h>", ":BufferLineCyclePrev<CR>", opts)
map("n", "<S-l>", ":BufferLineCycleNext<CR>", opts)

-- Terminal mode -> Normal mode (so you can scroll / page / copy).
-- <C-\> is the ToggleTerm toggle, so it eats the native <C-\><C-n>; use Esc.
-- Then: <C-u>/<C-d> scroll, PageUp/PageDown page, v + y to copy, i/a to type again.
map("t", "<Esc>", [[<C-\><C-n>]], opts)
-- Page directly while still in the shell (drops to Normal mode, then pages).
map("t", "<PageUp>", [[<C-\><C-n><C-b>]], opts)
map("t", "<PageDown>", [[<C-\><C-n><C-f>]], opts)
