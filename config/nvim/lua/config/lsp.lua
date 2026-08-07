-- LSP bootstrap for Nvim 0.12+
-- Server definitions live in `~/.config/nvim/lsp/<name>.lua`.
-- This file wires global capabilities, diagnostics, LspAttach behaviour,
-- and activates the server list via vim.lsp.enable().

local ok_blink, blink = pcall(require, "blink.cmp")
local capabilities = vim.lsp.protocol.make_client_capabilities()
if ok_blink then
	capabilities = blink.get_lsp_capabilities(capabilities)
end

vim.lsp.config("*", {
	capabilities = capabilities,
	root_markers = { ".git" },
})

-- User `lsp/*.lua` files are merged with matching runtime files. Since
-- nvim-lspconfig can be added to the runtime path later by lazy.nvim, make
-- these overrides explicit so its stock vtsls config cannot remove `vue`
-- from the configured filetypes.
local config_dir = vim.fn.stdpath("config")
vim.lsp.config("vtsls", dofile(vim.fs.joinpath(config_dir, "lsp", "vtsls.lua")))
vim.lsp.config("vue_ls", dofile(vim.fs.joinpath(config_dir, "lsp", "vue_ls.lua")))

vim.diagnostic.config({
	severity_sort = true,
	update_in_insert = false,
	underline = true,
	virtual_text = {
		spacing = 2,
		prefix = "●",
		severity = { min = vim.diagnostic.severity.HINT },
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.INFO] = "",
			[vim.diagnostic.severity.HINT] = "",
		},
	},
	float = {
		border = "rounded",
		source = true,
		header = "",
		prefix = "",
	},
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("user.lsp.attach", { clear = true }),
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if not client then return end

		if client:supports_method("textDocument/inlayHint") then
			vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
		end

		if client:supports_method("textDocument/documentHighlight") then
			local grp = vim.api.nvim_create_augroup("user.lsp.highlight." .. ev.buf, { clear = true })
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				group = grp,
				buffer = ev.buf,
				callback = vim.lsp.buf.document_highlight,
			})
			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "BufLeave" }, {
				group = grp,
				buffer = ev.buf,
				callback = vim.lsp.buf.clear_references,
			})
		end
	end,
})

vim.lsp.enable({
	"lua_ls",
	"gopls",
	"intelephense",
	"ols",
	"vtsls",
	"vue_ls",
	"jsonls",
	"dockerls",
	"docker_compose_ls",
	"protols",
	"bashls",
	"cssls",
	"eslint",
	"html",
	"tailwindcss",
	"yamlls",
	"marksman",
})
