local M = {}

function M.commentify(line)
    local pattern = vim.opt.commentstring:get()
    local commented_string = string.gsub(pattern, "%%s", line, 1)

    return commented_string
end

function M.uncommentify(line)
    local pattern = vim.opt.commentstring:get()
    pattern = "^" .. string.gsub(pattern, "%%s", ".*", 1) .. "$"

    local uncommented_string = string.gsub(line, "pattern", "%1")
    return uncommented_string
end

function M.add_comment()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line = vim.api.nvim_buf_get_lines(0, row-1, row, true)
    line[1] = M.commentify(line[1])
    vim.api.nvim_buf_set_lines(0, row-1, row, true, line)
    vim.api.nvim_win_set_cursor(0, {math.min(vim.api.nvim_buf_line_count(0), row+1), col})
end


function M.remove_comment()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line = vim.api.nvim_buf_get_lines(0, row-1, row, true)
    line[1] = M.uncommentify(line[1])
    vim.api.nvim_buf_set_lines(0, row-1, row, true, line)
    vim.api.nvim_win_set_cursor(0, {math.min(vim.api.nvim_buf_line_count(0), row+1), col})
end

vim.api.nvim_set_keymap('n', '<C-c>', "<Cmd>lua require('comment').add_comment()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-l>', "<Cmd>lua require('comment').remove_comment()<CR>", { noremap = true, silent = true })

return M
