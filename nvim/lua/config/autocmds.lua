vim.api.nvim_create_autocmd("FileType", {
    pattern = {"tex"},
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
        vim.opt_local.textwidth = 0
    end,
})

