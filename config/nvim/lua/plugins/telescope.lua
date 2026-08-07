return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                cond = function()
                    return vim.fn.executable("make") == 1
                end,
            },
        },
        opts = function(_, opts)
            local actions = require("telescope.actions")

            opts.defaults = opts.defaults or {}
            opts.defaults.file_ignore_patterns = opts.defaults.file_ignore_patterns or {}
            vim.list_extend(opts.defaults.file_ignore_patterns, {
                "%.git/",
                "node_modules/",
                "vendor/",
                "public/js/",
                "%.min%.js$",
                "%.min%.css$",
            })

            opts.defaults.mappings = opts.defaults.mappings or { i = {}, n = {} }

            -- Insert mode mappings (from your previous config)
            opts.defaults.mappings.i["<C-j>"] = actions.move_selection_next
            opts.defaults.mappings.i["<C-k>"] = actions.move_selection_previous
            opts.defaults.mappings.i["<Tab>"] = actions.toggle_selection + actions.move_selection_worse
            opts.defaults.mappings.i["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better
            opts.defaults.mappings.i["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist

            return opts
        end,
        config = function(_, opts)
            require("telescope").setup(opts)
            pcall(require("telescope").load_extension, "fzf")
            pcall(require("telescope").load_extension, "harpoon")
        end,
    },
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = {
            "nvim-telescope/telescope.nvim",
            "nvim-lua/plenary.nvim"
        }
    },
}
