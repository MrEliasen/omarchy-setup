return {
    {
        "j-hui/fidget.nvim",
        event = "LspAttach",
        opts = {
            progress = {
                display = {
                    progress_icon = "…",
                    done_icon = "✓",
                    done_ttl = 0,
                },
            },
            notification = {
                window = { winblend = 0 },
            },
        },
    },
}
