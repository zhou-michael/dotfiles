return {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    dependencies = {
        "rafamadriz/friendly-snippets",
    },
    config = function()
        local ls = require("luasnip")

        ls.config.set_config({
            history = true,
            updateevents = "TextChanged,TextChangedI",
            enable_autosnippets = true,
            ext_opts = {
                [require("luasnip.util.types").choiceNode] = {
                    active = { virt_text = { { "●", "GruvboxOrange" } } },
                },
            },
        })

        -- load vscode-style snippets from friendly-snippets
        require("luasnip.loaders.from_vscode").lazy_load()

        -- load Lua-format snippets (luasnippets/ directory)
        require("luasnip.loaders.from_lua").lazy_load({
            paths = vim.fn.stdpath("config") .. "/luasnippets",
        })

        -- jump forward/backward in snippet with <Tab>/<S-Tab> (insert + select modes)
        vim.keymap.set({ "i", "s" }, "<Tab>", function()
            if ls.locally_jumpable(1) then ls.jump(1) end
        end, { silent = true })
        vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
            if ls.locally_jumpable(-1) then ls.jump(-1) end
        end, { silent = true })

        -- cycle through choice nodes
        vim.keymap.set({ "i", "s" }, "<C-l>", function()
            if ls.choice_active() then ls.change_choice(1) end
        end, { silent = true })
    end,
}
