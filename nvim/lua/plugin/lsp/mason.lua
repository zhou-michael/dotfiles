return {
    "williamboman/mason.nvim",
    lazy = false,
    priority = 60,
    opts = {
        ui = {
            border = "rounded",
        },
    },
    config = function(_, opts)
        require("mason").setup(opts)
    end,
}
