local function getLsp()
  local msg = "No Active Lsp"
  local bufnr = 0
  local buf_ft = vim.bo[bufnr].filetype

  -- Prefer clients attached to this buffer
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  if not clients or vim.tbl_isempty(clients) then
    return msg
  end

  for _, client in ipairs(clients) do
    local filetypes = client.config and client.config.filetypes
    if filetypes and vim.tbl_contains(filetypes, buf_ft) then
      return client.name
    end
  end

  return msg
end


return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      -- Options
      opts.options = vim.tbl_deep_extend("force", opts.options or {}, {
        globalstatus = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        -- lualine expects this structure in newer versions
        disabled_filetypes = {
          statusline = { "neo-tree-popup", "alpha" },
        },
      })

      -- Replace sections with your layout
      opts.sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff" },
        lualine_c = { "filename" },
        lualine_x = { "diagnostics", getLsp, "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      }

      opts.inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      }

      opts.extensions = { "neo-tree", "toggleterm" }

      return opts
    end,
  },
}
