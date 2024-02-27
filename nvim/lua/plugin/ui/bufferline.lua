return {
    "akinsho/bufferline.nvim",
    lazy = false,
    config = function(_, opts)
        require("bufferline").setup(opts)
    end,
}

