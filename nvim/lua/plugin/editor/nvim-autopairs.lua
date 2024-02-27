return {
    "windwp/nvim-autopairs",
    lazy = false,
    config = function(_, opts)
        require("nvim-autopairs").setup(opts)
    end
}

