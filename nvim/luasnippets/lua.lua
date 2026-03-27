local ls = require("luasnip")
local s  = ls.snippet
local t  = ls.text_node
local i  = ls.insert_node

return {
    s("lsp", {
        t("lspconfig."),
        i(1, "server"),
        t(".setup("),
        i(2, "default_opt"),
        t(")"),
        i(0),
    }),
}, {}
