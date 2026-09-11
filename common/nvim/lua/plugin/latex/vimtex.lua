return {
    "lervag/vimtex",
    lazy = false,
    config = function(_, _)
        if vim.fn.has("mac") == 1 then
            vim.g.vimtex_view_method = "sioyek"
            vim.g.vimtex_view_skim_sync = 1
            vim.g.vimtex_view_skim_reading_bar = 1
        else
            vim.g.vimtex_view_method = "zathura"
        end
        vim.g.vimtex_compiler_latexmk = {
            out_dir = "build",
        }
        vim.g.tex_conceal = "abdmgs"
    end
}

