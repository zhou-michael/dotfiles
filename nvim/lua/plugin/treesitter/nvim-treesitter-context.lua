return {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "BufReadPre",
    opts = {
        max_lines = 3,        -- max lines of context shown at top
        min_window_height = 20,
        mode = "cursor",      -- show context for node under cursor
        separator = "─",
    },
}
