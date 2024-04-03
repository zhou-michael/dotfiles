return {
    "lervag/vimtex",
    lazy = false,
    config = function(_, _)
        vim.g.vimtex_view_method = "general"
        vim.g.vimtex_quickfix_mode = 1
        vim.g.vimtex_compiler_latexmk = {
            out_dir = "build",
        }
        vim.g.tex_conceal = "abdmgs"
    end
}

