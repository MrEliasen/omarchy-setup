local vue_plugin = vim.fn.stdpath("data")
	.. "/mason/packages/vue-language-server/node_modules/@vue/language-server"
local root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" }

return {
	cmd = { "vtsls", "--stdio" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"vue",
	},
	root_markers = root_markers,
	root_dir = function(bufnr, on_dir)
		on_dir(vim.fs.root(bufnr, root_markers) or vim.fn.getcwd())
	end,
	settings = {
		vtsls = {
			tsserver = {
				globalPlugins = {
					{
						name = "@vue/typescript-plugin",
						location = vue_plugin,
						languages = { "vue" },
						configNamespace = "typescript",
						enableForWorkspaceTypeScriptVersions = true,
					},
				},
			},
		},
	},
}
