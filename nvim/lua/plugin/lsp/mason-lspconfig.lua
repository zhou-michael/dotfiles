return {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
        "williamboman/mason.nvim",
        "neovim/nvim-lspconfig",
    },
    lazy = false,
    priority = 50,
    opts = {},
    config = function(_, opts)
        require("mason-lspconfig").setup(opts)
        require("mason-lspconfig").setup_handlers({
            function(server_name) -- default handler
                require("lspconfig")[server_name].setup({})
            end,

            ["lua_ls"] = function()
                require("lspconfig").lua_ls.setup({
                    settings = {
                        Lua = {
                            diagnostics = {
                                globals = {
                                    'vim'
                                }
                            }
                        }
                    }
                })
            end,

            ["clangd"] = function()
                require("lspconfig").clangd.setup({
                    settings = {

                    }
                })
            end,

            ["pyright"] = function()
                require("lspconfig").pyright.setup({
                    
                })
            end,
        })
    end,
}
