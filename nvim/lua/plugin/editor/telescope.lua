return {
    "nvim-telescope/telescope.nvim",
    lazy = false,
    branch = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
        },
    },
    config = function()
        local telescope = require("telescope")
        telescope.setup({
            defaults = {
                sorting_strategy = "ascending",
                layout_config = {
                    horizontal = { prompt_position = "top", preview_width = 0.55 },
                },
                mappings = {
                    i = {
                        ["<C-j>"] = "move_selection_next",
                        ["<C-k>"] = "move_selection_previous",
                        ["<Esc>"] = "close",
                    },
                },
            },
            pickers = {
                find_files = { hidden = true },
            },
        })
        telescope.load_extension("fzf")
    end,
}
