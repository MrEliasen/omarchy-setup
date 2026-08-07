return {
    {
        'saghen/blink.cmp',
        dependencies = { 'rafamadriz/friendly-snippets' },
        version = '1.*',
        lazy = false,
        opts = function(_, opts)
            opts.keymap = opts.keymap or {}
            opts.keymap.preset = "default"
            opts.keymap["<CR>"] = { "accept", "fallback" }
            opts.keymap['<C-k>'] = { 'select_prev', 'fallback' }
            opts.keymap['<C-j>'] = { 'select_next', 'fallback' }

            opts.completion = opts.completion or {}
            opts.completion.accept = opts.completion.accept or {}
            opts.completion.accept.resolve_timeout_ms = 600

            opts.sources = opts.sources or {}
            opts.sources.providers = opts.sources.providers or {}
            opts.sources.providers.lsp = opts.sources.providers.lsp or {}
            opts.sources.providers.lsp.timeout_ms = 100

            local function ols_import_collection(ctx)
                local item = ctx.item
                local edits = item.additionalTextEdits
                if edits and edits[1] and edits[1].newText then
                    local coll = edits[1].newText:match('import%s+"([^:"]+):')
                    if coll then return coll end
                end
                local doc = item.documentation
                local val = type(doc) == "table" and doc.value or (type(doc) == "string" and doc) or nil
                if val then
                    local coll = val:match('import%s+"([^:"]+):')
                    if coll then return coll end
                end
                return ""
            end

            opts.completion.menu = opts.completion.menu or {}
            opts.completion.menu.draw = opts.completion.menu.draw or {}
            opts.completion.menu.draw.columns = {
                { "kind_icon" },
                { "label", "label_description", gap = 1 },
                { "import_source", gap = 1 },
            }
            opts.completion.menu.draw.components = opts.completion.menu.draw.components or {}
            opts.completion.menu.draw.components.import_source = {
                text = ols_import_collection,
                highlight = "BlinkCmpLabelDescription",
            }

            return opts
        end,
    }
}
