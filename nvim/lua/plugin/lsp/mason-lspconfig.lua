return {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
        "williamboman/mason.nvim",
        "neovim/nvim-lspconfig",
        "Saghen/blink.cmp",
    },
    lazy = false,
    priority = 50,
    opts = {
        ensure_installed = {
            -- already configured
            "lua_ls",
            "clangd",
            "pyright",
            -- web
            "ts_ls",
            "html",
            "cssls",
            "jsonls",
            -- systems
            "rust_analyzer",
            "gopls",
            -- scripting / config
            "bashls",
            "yamlls",
            -- docs
            "marksman",
            -- latex (LSP diagnostics; vimtex handles compilation/preview)
            "texlab",
        },
    },
    config = function(_, opts)
        require("mason-lspconfig").setup(opts)

        local capabilities = require("blink.cmp").get_lsp_capabilities()
        local lspconfig = require("lspconfig")

        require("mason-lspconfig").setup_handlers({
            -- default handler: all servers not listed below
            function(server_name)
                lspconfig[server_name].setup({ capabilities = capabilities })
            end,

            ["lua_ls"] = function()
                lspconfig.lua_ls.setup({
                    capabilities = capabilities,
                    settings = {
                        Lua = {
                            diagnostics = { globals = { "vim" } },
                            workspace = { checkThirdParty = false },
                            telemetry = { enable = false },
                        },
                    },
                })
            end,

            ["clangd"] = function()
                lspconfig.clangd.setup({
                    capabilities = capabilities,
                    cmd = {
                        "clangd",
                        "--background-index",
                        "--clang-tidy",
                        "--header-insertion=iwyu",
                        "--completion-style=detailed",
                    },
                })
            end,

            ["pyright"] = function()
                lspconfig.pyright.setup({
                    capabilities = capabilities,
                    settings = {
                        python = {
                            analysis = {
                                typeCheckingMode = "basic",
                                autoImportCompletions = true,
                            },
                        },
                    },
                })
            end,

            ["texlab"] = function()
                lspconfig.texlab.setup({
                    capabilities = capabilities,
                    settings = {
                        texlab = {
                            build = {
                                onSave = false, -- vimtex handles building
                            },
                            chktex = { onOpenAndSave = true },
                        },
                    },
                })
            end,

            ["ts_ls"] = function()
                lspconfig.ts_ls.setup({
                    capabilities = capabilities,
                    settings = {
                        typescript = { inlayHints = { includeInlayParameterNameHints = "all" } },
                        javascript = { inlayHints = { includeInlayParameterNameHints = "all" } },
                    },
                })
            end,

            ["rust_analyzer"] = function()
                lspconfig.rust_analyzer.setup({
                    capabilities = capabilities,
                    settings = {
                        ["rust-analyzer"] = {
                            checkOnSave = { command = "clippy" },
                            inlayHints = { enable = true },
                        },
                    },
                })
            end,

            ["gopls"] = function()
                lspconfig.gopls.setup({
                    capabilities = capabilities,
                    settings = {
                        gopls = {
                            analyses = { unusedparams = true },
                            staticcheck = true,
                        },
                    },
                })
            end,
        })
    end,
}
