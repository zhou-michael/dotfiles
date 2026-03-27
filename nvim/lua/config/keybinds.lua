-- nnn file manager
vim.keymap.set("n", "<Leader>n",   "<cmd>NnnExplorer<CR>")
vim.keymap.set("n", "<Leader>N",   "<cmd>NnnExplorer %:p:h<CR>")
vim.keymap.set("n", "<Leader>m",   "<cmd>NnnPicker<CR>")
vim.keymap.set("n", "<Leader>M",   "<cmd>NnnPicker %:p:h<CR>")

-- buffer navigation
vim.keymap.set("n", "<Leader>b",   "<cmd>bnext<CR>",     { desc = "Next buffer" })
vim.keymap.set("n", "<Leader>B",   "<cmd>bprev<CR>",     { desc = "Prev buffer" })

-- telescope
local function telescope(picker, opts)
    return function()
        require("telescope.builtin")[picker](opts or {})
    end
end

vim.keymap.set("n", "<Leader>ff", telescope("find_files"),                             { desc = "Find files" })
vim.keymap.set("n", "<Leader>fg", telescope("live_grep"),                              { desc = "Live grep" })
vim.keymap.set("n", "<Leader>fb", telescope("buffers"),                                { desc = "Buffers" })
vim.keymap.set("n", "<Leader>fh", telescope("help_tags"),                              { desc = "Help tags" })
vim.keymap.set("n", "<Leader>fd", telescope("diagnostics"),                            { desc = "Diagnostics" })
vim.keymap.set("n", "<Leader>fr", telescope("lsp_references"),                         { desc = "LSP references" })
vim.keymap.set("n", "<Leader>fs", telescope("lsp_document_symbols"),                   { desc = "Document symbols" })
vim.keymap.set("n", "<Leader>fS", telescope("lsp_workspace_symbols"),                  { desc = "Workspace symbols" })
vim.keymap.set("n", "<Leader>fo", telescope("oldfiles"),                               { desc = "Recent files" })
vim.keymap.set("n", "<Leader>fw", telescope("grep_string"),                            { desc = "Grep word under cursor" })
vim.keymap.set("n", "<Leader>t",  "<cmd>Telescope<CR>",                               { desc = "Telescope picker list" })
