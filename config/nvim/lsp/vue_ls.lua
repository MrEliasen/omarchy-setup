return {
	cmd = { "vue-language-server", "--stdio" },
	filetypes = { "vue" },
	root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
	on_init = function(client)
		client.handlers["tsserver/request"] = function(_, result, context)
			local function forward(attempt)
				local ts_client = vim.lsp.get_clients({
					bufnr = context.bufnr,
					name = "vtsls",
				})[1]

				if not ts_client then
					-- Both clients start asynchronously. Large projects can take
					-- longer than nvim-lspconfig's default one-second retry window.
					if attempt < 100 then
						vim.defer_fn(function()
							forward(attempt + 1)
						end, 100)
					else
						vim.notify(
							"vtsls did not attach to this Vue buffer; check :LspInfo for its startup error.",
							vim.log.levels.ERROR
						)
					end
					return
				end

				local params = unpack(result)
				local id, command, payload = unpack(params)
				ts_client:exec_cmd({
					title = "vue_request_forward",
					command = "typescript.tsserverRequest",
					arguments = { command, payload },
				}, { bufnr = context.bufnr }, function(_, response)
					client:notify("tsserver/response", { { id, response and response.body } })
				end)
			end

			forward(1)
		end
	end,
}
