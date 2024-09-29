return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 1000,
        opts = {
            flavour = "mocha",
            transparent_background = false,
            integrations = {
                notify = true
            }
        },
        config = function(_, opts)
            require("catppuccin").setup(opts)
            vim.cmd([[colorscheme catppuccin]])
        end
    },
    {
        "folke/tokyonight.nvim",
        name = "tokyonight",
        lazy = true,
        priority = 1000,
        config = function()
            vim.cmd([[colorscheme tokyonight]])
        end
    },
    {
        dir = "~/Documents/beepboop/matcha",
        lazy = true,
        config = function(_, opts)
            -- vim.cmd("colorscheme matcha")
        end
    }
}
