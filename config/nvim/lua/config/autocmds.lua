-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
vim.filetype.add({
    extension = {
        odin = "odin",
        gosum = "gosum",
        gotmpl = "gotmpl",
    },
    filename = {
        ["docker-compose.yml"] = "yaml.docker-compose",
        ["docker-compose.yaml"] = "yaml.docker-compose",
        ["compose.yml"] = "yaml.docker-compose",
        ["compose.yaml"] = "yaml.docker-compose",
    },
    pattern = {
        [".*%.blade%.php"] = "blade",
    },
})

vim.treesitter.language.register("yaml", { "yaml.docker-compose" })

local aug = vim.api.nvim_create_augroup
local aucmd = vim.api.nvim_create_autocmd
local grp = aug("user_filetype_indent", { clear = true })

aucmd("FileType", {
    group = aug("user_disable_web_autoformat", { clear = true }),
    pattern = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "vue",
    },
    callback = function()
        vim.b.autoformat = false
    end,
})

-- 2-space ecosystems
aucmd("FileType", {
    group = grp,
    pattern = {
        "dart",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "vue",
        "json",
        "yaml",
        "css",
        "scss",
        "html",
    },
    callback = function()
        vim.bo.shiftwidth = 2
        vim.bo.tabstop = 2
        vim.bo.softtabstop = 2
        vim.bo.expandtab = true
    end,
})

-- Go
aucmd("FileType", {
    group = grp,
    pattern = { "go" },
    callback = function()
        vim.bo.expandtab = false
        vim.bo.tabstop = 4
        vim.bo.shiftwidth = 4
        vim.bo.softtabstop = 4
    end,
})

-- PHP + Blade (4 spaces)
aucmd("FileType", {
    group = grp,
    pattern = { "php", "blade" },
    callback = function()
        vim.bo.shiftwidth = 4
        vim.bo.tabstop = 4
        vim.bo.softtabstop = 4
        vim.bo.expandtab = true
    end,
})

-- Spell only for prose filetypes
aucmd("FileType", {
    group = grp,
    pattern = { "markdown", "gitcommit", "text", "help" },
    callback = function()
        vim.opt_local.spell = true
    end,
})
