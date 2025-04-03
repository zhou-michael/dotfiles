-- TeX customizations
vim.api.nvim_create_autocmd("FileType", {
    pattern = {"tex"},
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
        vim.opt_local.textwidth = 0
    end,
})

-- Automatically open nnn when opening a directory
vim.api.nvim_create_autocmd("VimEnter", {
  pattern = "*",
  callback = function()
    local filepath = vim.fn.expand('%:p')  -- Get the current file's path
    if vim.fn.isdirectory(filepath) == 1 then
      -- If it's a directory, open `nnn` in a terminal
      vim.cmd('NnnExplorer')  -- Open nnn in a terminal inside Neovim
    end
  end
})
