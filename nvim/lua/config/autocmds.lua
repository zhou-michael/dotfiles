-- TeX customizations
vim.api.nvim_create_autocmd("FileType", {
    pattern = {"tex"},
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
        vim.opt_local.textwidth = 0

        -- set shorter name for keymap function

--        local kmap = vim.keymap.set
--        local knap = require('knap')
--
--        -- F5 processes the document once, and refreshes the view
--        kmap({ 'n', 'v', 'i' },'<Leader>r', function() knap.process_once() end)
--
--        -- F6 closes the viewer application, and allows settings to be reset
--        kmap({ 'n', 'v', 'i' },'<Leader>c', function() knap.close_viewer() end)
--
--        -- F7 toggles the auto-processing on and off
--        kmap({ 'n', 'v', 'i' },'<Leader>l', function() knap.toggle_autopreviewing() end)
--
--        -- F8 invokes a SyncTeX forward search, or similar, where appropriate
--        kmap({ 'n', 'v', 'i' },'<Leader>s', function() knap.forward_jump() end)
--
--        local gknapsettings = {
--            texoutputext = "pdf",
--            textopdf = "pdflatex -synctex=1 -output-directory=build -halt-on-error -interaction=batchmode %docroot%",
--            textopdfviewerlaunch = "sioyek build/%outputfile%",
--            textopdfviewerrefresh = "kill -HUP %pid%"
--        }
--        vim.g.knap_settings = gknapsettings
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

        -- don't enable COQ on tex files
        if vim.bo.filetype ~= "tex" then
            vim.cmd('COQnow --shut-up')
        end
    end
})
