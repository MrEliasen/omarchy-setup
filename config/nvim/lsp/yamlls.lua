return {
	cmd = { "yaml-language-server", "--stdio" },
	filetypes = { "yaml", "yaml.docker-compose" },
	root_markers = { ".git" },
	settings = {
		redhat = { telemetry = { enabled = false } },
		yaml = {
			keyOrdering = false,
			format = { enable = true },
			validate = true,
			schemaStore = {
				enable = false,
				url = "",
			},
			schemas = {
				["https://json.schemastore.org/github-workflow.json"] = ".github/workflows/*.{yml,yaml}",
				["https://json.schemastore.org/github-action.json"] = ".github/action.{yml,yaml}",
				["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = {
					"docker-compose*.{yml,yaml}",
					"compose*.{yml,yaml}",
				},
				kubernetes = { "k8s/**/*.yaml", "kube/**/*.yaml" },
			},
		},
	},
}
