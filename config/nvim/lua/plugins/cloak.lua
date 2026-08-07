return {
    {
        "laytan/cloak.nvim",
        event = "VeryLazy",
        opts = {
            enabled = true,
            cloak_character = "•",
            highlight_group = "Comment",
            patterns = {
                {
                    file_pattern = { ".env*", "wrangler.toml", ".npmrc" },
                    cloak_pattern = "=.+",
                },
            },
        },
    },
}
