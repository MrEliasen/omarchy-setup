return {
	cmd = { "intelephense", "--stdio" },
	filetypes = { "php", "blade" },
	root_markers = { "composer.json", "artisan", ".git" },
	settings = {
		intelephense = {
			files = {
				maxSize = 5000000,
			},
			format = { enable = false },
			completion = {
				insertUseDeclaration = true,
				triggerParameterHints = true,
			},
		},
	},
}
