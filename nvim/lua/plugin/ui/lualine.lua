return {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    opts = {
        options = {
            section_separators = { left = "", right = "" },
            component_separators = { left = "|", right = "|" },
        },
        sections = {
            lualine_a = {"mode"},
            lualine_b = {"branch", "diff"},
            lualine_c = {"filename", "diagnositcs"}, lualine_x = {"encoding", "fileformat", "filetype"}, lualine_y = {"progress"},
            lualine_z = {"location"} }
    },
    config = function(_, opts)
        require("lualine").setup(opts)
    end,
}

