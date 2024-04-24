return {
    "SirVer/ultisnips",
    lazy = false,
    config = function(_, _)
        vim.g.UltiSnipsExpandTrigger = "<tab>"
        vim.g.UltiSnipsJumpForwardTrigger = "<c-c>"
        vim.g.UltiSnipsJumpBackwardTrigger = "<c-x>"
    end
}
