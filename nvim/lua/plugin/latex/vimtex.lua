return {
    "lervag/vimtex",
    lazy = false,
    config = function(_, _)
        vim.g.vimtex_view_method = "skim"
        vim.g.vimtex_quickfix_mode = 1
        vim.g.vimtex_view_skim_sync = 1
        vim.g.vimtex_view_skim_reading_bar = 1
        vim.g.vimtex_compiler_latexmk = {
            out_dir = "build",
        }
        vim.g.tex_conceal = "abdmgs"
    end
}

