return {
    {
        "neovim/nvim-lspconfig",
        lazy = false,
    },
    {
        "williamboman/mason.nvim",
        lazy = false,
        priority = 60,
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "neovim/nvim-lspconfig",
        },
        opts = {
            ui = {
                border = "rounded",
            },
        },
        config = function(_, opts)
            require("mason").setup(opts)
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        priority = 50,
        opts = {},
        config = function(_, opts)
            require("mason-lspconfig").setup(opts)
            require("mason-lspconfig").setup_handlers({
                function(server_name) -- default handler
                    require("lspconfig")[server_name].setup({})
                end,
            })
        end,
    }
}
