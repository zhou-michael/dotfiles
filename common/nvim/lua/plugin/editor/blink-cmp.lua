return {
    "Saghen/blink.cmp",
    lazy = false,
    version = "*",
    dependencies = {
        "L3MON4D3/LuaSnip",
    },
    opts = {
        keymap = {
            preset = "default",
            ["<C-b>"]     = { "scroll_documentation_up",   "fallback" },
            ["<C-f>"]     = { "scroll_documentation_down", "fallback" },
            ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
            ["<C-e>"]     = { "hide", "fallback" },
            ["<CR>"]      = { "accept", "fallback" },
            ["<Tab>"]     = { "snippet_forward", "fallback" },
            ["<S-Tab>"]   = { "snippet_backward", "fallback" },
        },
        appearance = {
            kind_icons = {
                Text = "", Method = "󰆧", Function = "󰊕", Constructor = "",
                Field = "󰇽", Variable = "󰂡", Class = "󰠱", Interface = "",
                Module = "", Property = "󰜢", Unit = "", Value = "󰎠",
                Enum = "", Keyword = "󰌋", Snippet = "", Color = "󰏘",
                File = "󰈙", Reference = "", Folder = "󰉋", EnumMember = "",
                Constant = "󰏿", Struct = "", Event = "", Operator = "󰆕",
                TypeParameter = "󰅲",
            },
        },
        sources = {
            default = { "lsp", "path", "snippets", "buffer" },
        },
        snippets = { preset = "luasnip" },
        completion = {
            documentation = { auto_show = true, auto_show_delay_ms = 200 },
        },
        enabled = function()
            if vim.bo.filetype == "tex" then return false end
            if vim.bo.buftype == "prompt" then return false end
            if vim.fn.reg_recording() ~= "" then return false end
            if vim.fn.reg_executing() ~= "" then return false end
            return true
        end,
        signature = { enabled = true },
    },
}
