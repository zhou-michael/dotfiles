return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = true,
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
        end
    },
    {
        "folke/tokyonight.nvim",
        name = "tokyonight",
        lazy = true,
        priority = 1000,
        config = function()
        end
    },
--    {
--        dir = "~/Documents/beepboop/cha",
--        lazy = true,
--        config = function(_, opts)
--            require("cha").setup(opts)
--        end
--    }
}
