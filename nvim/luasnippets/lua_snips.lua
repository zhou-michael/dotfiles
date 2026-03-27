local ls = require("luasnip")
local s  = ls.snippet
local t  = ls.text_node
local i  = ls.insert_node

-- NOTE: this file is named lua_snips.lua (not lua.lua) to avoid a module name collision.
-- The loader maps it to filetype "lua" via the filename without the directory path,
-- so rename the file to lua.lua if LuaSnip supports it; otherwise register manually.

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
