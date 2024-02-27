return {
    "nvim-neo-tree/neo-tree.nvim",
    lazy = false,
    main = "neo-tree",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
    },
    opts = {
        window = {
            width = 28
        },
        default_component_configs = {
            file_size = {
                enabled = true,
                required_width = 40, -- min width of window required to show this column
            },
            type = {
                enabled = true,
                required_width = 70, -- min width of window required to show this column
            },
            last_modified = {
                enabled = true,
                required_width = 60, -- min width of window required to show this column
            },
            created = {
                enabled = true,
                required_width = 100, -- min width of window required to show this column
            },
            symlink_target = {
                enabled = true,
                required_width = 80,
            },
        },
    },
}
