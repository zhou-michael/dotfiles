return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        delay = 400,
        spec = {
            { "<leader>h", group = "git hunks / diff" },
            { "<leader>f", group = "find / telescope" },
            { "<leader>b", group = "buffer" },
            { "<space>w",  group = "workspace folders" },
            { "<space>",   group = "lsp" },
        },
    },
}
