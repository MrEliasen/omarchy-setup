local parsers = {
	"markdown",
	"markdown_inline",
	"html",
	"css",
	"javascript",
	"typescript",
	"tsx",
	"json",
	"svelte",
	"odin",
	"scss",
	"c",
	"python",
	"php",
	"php_only",
	"phpdoc",
	"vue",
	"dockerfile",
	"yaml",
	"toml",
	"lua",
	"luadoc",
	"luap",
	"bash",
	"regex",
	"vim",
	"vimdoc",
	"query",
	"go",
	"gomod",
	"gosum",
	"gowork",
	"gotmpl",
	"proto",
	"rust",
}

return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").install(parsers)

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("user.treesitter.ft", { clear = true }),
				callback = function(ev)
					local lang = vim.treesitter.language.get_lang(ev.match) or ev.match
					local ok, _ = pcall(vim.treesitter.start, ev.buf, lang)
					if ok then
						vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
				end,
			})
		end,
	},
}
