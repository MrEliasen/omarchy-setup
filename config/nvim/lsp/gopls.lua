return {
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gosum", "gotmpl" },
	root_markers = { "go.mod", "go.sum", ".git" },
	settings = {
		gopls = {
			gofumpt = true,
			staticcheck = true,
			analyses = {
				unusedparams = true,
				nilness = true,
				unusedwrite = true,
				useany = true,
			},
			hints = {
				assignVariableTypes = true,
				compositeLiteralFields = true,
				compositeLiteralTypes = true,
				constantValues = true,
				functionTypeParameters = true,
				parameterNames = true,
				rangeVariableTypes = true,
			},
		},
	},
}
