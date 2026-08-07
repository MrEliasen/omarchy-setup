-- Project search / replace user commands (unchanged, kept for convenience)
vim.api.nvim_create_user_command("FindInProject", function(opts)
	if #opts.fargs ~= 2 then
		vim.notify("FindInProject expects 2 args: <pattern> <glob>", vim.log.levels.ERROR)
		return
	end

	local pattern = vim.fn.escape(opts.fargs[1], [[/\]])
	local glob = opts.fargs[2]

	vim.cmd(("silent vimgrep /%s/gj %s"):format(pattern, glob))
	vim.cmd("copen")
end, { nargs = "+" })

vim.api.nvim_create_user_command("FindAndReplace", function(opts)
	if #opts.fargs ~= 2 then
		vim.notify("FindAndReplace expects exactly 2 arguments", vim.log.levels.ERROR)
		return
	end

	local find = vim.fn.escape(opts.fargs[1], [[/\]])
	local repl = vim.fn.escape(opts.fargs[2], [[/\&]])

	vim.cmd(("cfdo %%s/%s/%s/g | update"):format(find, repl))
end, { nargs = "+" })

return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			preset = "helix",
			delay = 0,
			triggers = {
				{ "<leader>", mode = { "n", "v" } },
			},
		},
		keys = {
			{ "<leader>w",  "<cmd>w<cr>",                                                                          mode = "n", desc = "Save" },
			{ "<leader>q",  "<cmd>q<cr>",                                                                          mode = "n", desc = "Quit" },
			{ "<leader>s",  group = "Search & Replace" },
			{ "<leader>sc", "<cmd>:let @/=''<CR>",                                                                 mode = "n", desc = "Clear" },
			{ "<leader>ss", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],                                mode = "n", desc = "File Replace Word" },
			{ "<leader>sd", [[:.,.+25s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],                           mode = "n", desc = "Next 25L - Replace Word" },
			{ "<leader>sf", [[:.,.+0s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],                            mode = "n", desc = "Same Line - Replace Word" },
			{ "<leader>p",  group = "Project" },
			{ "<leader>pv", "<cmd>Ex<CR>",                                                                         mode = "n", desc = "NetRW Explorer" },
			{ "<leader>f",  group = "Find" },
			{ "<leader>ft", "<cmd>lua require('telescope.builtin').live_grep()<CR>",                               mode = "n", desc = "Text" },
			{ "<leader>ff", "<cmd>lua require('telescope.builtin').find_files({ hidden=true })<CR>",               mode = "n", desc = "Files" },
			{ "<leader>fr", "<cmd>lua require('telescope.builtin').resume()<CR>",                                  mode = "n", desc = "Resume last search" },
			{ "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<CR>",                               mode = "n", desc = "Help tags" },
			{ "<leader>fb", "<cmd>lua require('telescope').extensions.file_browser.file_browser()<CR>",            mode = "n", desc = "Browse Files" },
			{ "<leader>fB", "<cmd>lua require('telescope').extensions.file_browser.file_browser(%:p:h, true)<CR>", mode = "n", desc = "Browse Relative" },
			{ "<leader>fF", ":FindInProject ",                                                                     mode = "n", desc = "Find in project" },
			{ "<leader>fR", ":FindAndReplace ",                                                                    mode = "n", desc = "Find replace across project" },
			{ "<leader>m",  group = "Markdown" },
			{ "<leader>mm", "<cmd>:MarkdownPreview<cr>",                                                           mode = "n", desc = "Start Preview" },
			{ "<leader>ms", "<cmd>:MarkdownPreviewStop<cr>",                                                       mode = "n", desc = "Stop Preview" },
			{ "<leader>mr", "<cmd>:MarkdownPreviewRefresh<cr>",                                                    mode = "n", desc = "Refresh Preview" },
			{ "<leader>b",  group = "Buffers" },
			{ "<leader>bd", "<cmd>bdelete<cr>",                                                                    mode = "n", desc = "Close Current" },
			{ "<leader>bm", "<cmd>BufferLineCloseRight<cr><cmd>BufferLineCloseLeft<cr>",                           mode = "n", desc = "Close all other" },
			{ "<leader>bl", "<cmd>BufferLineCloseRight<cr>",                                                       mode = "n", desc = "Close right" },
			{ "<leader>bh", "<cmd>BufferLineCloseLeft<cr>",                                                        mode = "n", desc = "Close left" },
			{ "<leader>h",  group = "Harpoon" },
			{ "<leader>he", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end,     mode = "n", desc = "View Marked Files" },
			{ "<leader>hh", function() require("harpoon"):list():add() end,                                        mode = "n", desc = "Mark file" },
			{ "<leader>hf", function() require("harpoon"):list():select(1) end,                                    mode = "n", desc = "Nav file 1" },
			{ "<leader>hd", function() require("harpoon"):list():select(2) end,                                    mode = "n", desc = "Nav file 2" },
			{ "<leader>hs", function() require("harpoon"):list():select(3) end,                                    mode = "n", desc = "Nav file 3" },
			{ "<leader>ha", function() require("harpoon"):list():select(4) end,                                    mode = "n", desc = "Nav file 4" },
			{ "<leader>l",  group = "LSP" },
			{ "<leader>ld", vim.lsp.buf.definition,                                                                mode = "n", desc = "Definition" },
			{ "<leader>lD", vim.lsp.buf.declaration,                                                               mode = "n", desc = "Declaration" },
			{ "<leader>li", vim.lsp.buf.implementation,                                                            mode = "n", desc = "Implementation" },
			{ "<leader>lR", vim.lsp.buf.references,                                                                mode = "n", desc = "References" },
			{ "<leader>lK", vim.lsp.buf.hover,                                                                     mode = "n", desc = "Hover" },
			{
				"<leader>ln",
				function() return ":IncRename " .. vim.fn.expand("<cword>") end,
				expr = true,
				mode = "n",
				desc = "Rename",
			},
			{ "<leader>la", function() require("actions-preview").code_actions() end,                              mode = "n", desc = "Code actions" },
			{ "<leader>lf", function() require("conform").format({ async = true, lsp_fallback = true }) end,       mode = "n", desc = "Format" },
			{ "<leader>lo", vim.diagnostic.open_float,                                                             mode = "n", desc = "Open diagnostic float" },
			{ "<leader>lj", function() vim.diagnostic.jump({ count = 1, on_jump = function() vim.diagnostic.open_float() end }) end,  mode = "n", desc = "Next diagnostic" },
			{ "<leader>lk", function() vim.diagnostic.jump({ count = -1, on_jump = function() vim.diagnostic.open_float() end }) end, mode = "n", desc = "Prev diagnostic" },
			{
				"<leader>lI",
				function()
					local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
					vim.lsp.inlay_hint.enable(not enabled, { bufnr = 0 })
				end,
				mode = "n",
				desc = "Toggle inlay hints",
			},
			{ "<leader>lh", "<cmd>lsp restart<cr>",                                                                mode = "n", desc = "Restart LSP client" },
			{ "<leader>ly", "<cmd>lsp enable<cr>",                                                                 mode = "n", desc = "Enable LSP" },
			{ "<leader>lx", "<cmd>lsp stop<cr>",                                                                   mode = "n", desc = "Stop LSP client" },
			{ "<leader>lc", "<cmd>checkhealth vim.lsp<cr>",                                                        mode = "n", desc = "LSP healthcheck" },
			{ "<leader>F",  group = "Flutter" },
			{ "<leader>FF", ":FlutterReload<cr>",                                                                  mode = "n", desc = "Reload" },
			{ "<leader>Fs", ":FlutterRun<cr>",                                                                     mode = "n", desc = "Start/Run" },
			{ "<leader>Fr", ":FlutterRestart<cr>",                                                                 mode = "n", desc = "Restart" },
			{ "<leader>Fd", ":FlutterDevices<cr>",                                                                 mode = "n", desc = "Devices" },
			{ "<leader>Fb", ":FlutterDebug<cr>",                                                                   mode = "n", desc = "Debug" },
			{ "<leader>Fq", ":FlutterQuit<cr>",                                                                    mode = "n", desc = "Quit" },
			{ "<leader>Fl", ":FlutterLspRestart<cr>",                                                              mode = "n", desc = "Restart LSP Server" },
			{ "<leader>Fn", ":FlutterRename<cr>",                                                                  mode = "n", desc = "Rename" },
			{ "<leader>ee", "oif err != nil {<CR>}<Esc>Oreturn err<Esc>",                                          mode = "n", desc = "Insert if err nil statement" },
			{ "<leader>eo", "oif !ok {<CR>}<Esc>Oreturn<Esc>",                                                     mode = "n", desc = "Insert if !ok statement" },
			{ "<leader>c",  group = "Cloak" },
			{ "<leader>cc", "<cmd>:CloakToggle<cr>",                                                               mode = "n", desc = "Toggle" },
			{ "<leader>u",  group = "Trouble" },
			{ "<leader>ur", "<cmd>Trouble lsp_references toggle<cr>",                                              mode = "n", desc = "References" },
			{ "<leader>uf", "<cmd>Trouble lsp_definitions toggle<cr>",                                             mode = "n", desc = "Definitions" },
			{ "<leader>ud", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",                                    mode = "n", desc = "Buffer diagnostics" },
			{ "<leader>uq", "<cmd>Trouble qflist toggle<cr>",                                                      mode = "n", desc = "QuickFix" },
			{ "<leader>ul", "<cmd>Trouble loclist toggle<cr>",                                                     mode = "n", desc = "LocationList" },
			{ "<leader>uw", "<cmd>Trouble diagnostics toggle<cr>",                                                 mode = "n", desc = "Workspace diagnostics" },
			{ "<leader>us", "<cmd>Trouble symbols toggle focus=false<cr>",                                         mode = "n", desc = "Document symbols" },
		},
	},
}
