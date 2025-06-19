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

        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        require("mason-lspconfig").setup_handlers({
            function(server_name) -- default handler
                require("lspconfig")[server_name].setup({
                    capabilities = capabilities
                })
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
                    },
                    capabilities = capabilities
                })
            end,

            ["clangd"] = function()
                require("lspconfig").clangd.setup({
                    settings = {

                    },
                    capabilities = capabilities
                })
            end,

            ["pyright"] = function()
                require("lspconfig").pyright.setup({
                    capabilites = capabilities
                })
            end,
        })
    end,
}
