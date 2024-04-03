return {
    "SirVer/ultisnips",
    lazy = false,
    config = function(_, _)
        vim.g.UltiSnipsExpandTrigger = "<tab>"
        vim.g.UltiSnipsJumpForwardTrigger = "<tab>"
        vim.g.UltiSnipsjumpBackwardTrigger = "<tab>"
    end
}
