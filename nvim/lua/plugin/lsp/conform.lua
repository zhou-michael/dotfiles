return {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = { "ConformInfo" },
    opts = {
        formatters_by_ft = {
            lua        = { "stylua" },
            python     = { "black", "isort" },
            javascript = { "prettier" },
            typescript = { "prettier" },
            javascriptreact = { "prettier" },
            typescriptreact = { "prettier" },
            json       = { "prettier" },
            yaml       = { "prettier" },
            html       = { "prettier" },
            css        = { "prettier" },
            markdown   = { "prettier" },
            cpp        = { "clang_format" },
            c          = { "clang_format" },
            rust       = { "rustfmt" },
            go         = { "gofmt" },
            sh         = { "shfmt" },
        },
        -- format on save with a short timeout; fall back to LSP if no formatter configured
        format_on_save = {
            timeout_ms = 500,
            lsp_fallback = true,
        },
    },
}
