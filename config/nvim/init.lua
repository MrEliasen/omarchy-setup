-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")

-- LazyVim enables these during setup; override them afterwards so editing
-- movement and all Snacks-powered UI transitions are immediate.
vim.g.snacks_animate = false
vim.opt.smoothscroll = false

require("config.lsp")
