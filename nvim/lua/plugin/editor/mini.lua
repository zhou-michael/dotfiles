return {
    -- gcc / gc{motion} to toggle comments
    {
        "echasnovski/mini.comment",
        version = "*",
        event = "VeryLazy",
        opts = {},
    },
    -- Extended text objects: a/i for functions, classes, arguments, etc.
    {
        "echasnovski/mini.ai",
        version = "*",
        event = "VeryLazy",
        opts = {},
    },
    -- <M-h/j/k/l> to move lines or visual selections
    {
        "echasnovski/mini.move",
        version = "*",
        event = "VeryLazy",
        opts = {
            mappings = {
                left  = "<M-h>",
                right = "<M-l>",
                down  = "<M-j>",
                up    = "<M-k>",
                line_left  = "<M-h>",
                line_right = "<M-l>",
                line_down  = "<M-j>",
                line_up    = "<M-k>",
            },
        },
    },
    -- <leader>bd to close buffer without closing window
    {
        "echasnovski/mini.bufremove",
        version = "*",
        event = "VeryLazy",
        config = function()
            require("mini.bufremove").setup()
            vim.keymap.set("n", "<leader>bd", function()
                require("mini.bufremove").delete(0, false)
            end, { desc = "Delete buffer" })
            vim.keymap.set("n", "<leader>bD", function()
                require("mini.bufremove").delete(0, true)
            end, { desc = "Force delete buffer" })
        end,
    },
}
