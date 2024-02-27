------------------------
--- Autopairs config ---
------------------------
local Rule = require('nvim-autopairs.rule')
local npairs = require('nvim-autopairs')
local cond = require('nvim-autopairs.conds')
local utils = require('nvim-autopairs.utils')
--local ts_conds = require('nvim-autopairs.ts-conds')
local remap = vim.api.nvim_set_keymap

remap('i', '<esc>', [[pumvisible() ? "<c-e><esc>" : "<esc>"]], { expr = true, noremap = true })
remap('i', '<c-c>', [[pumvisible() ? "<c-e><c-c>" : "<c-c>"]], { expr = true, noremap = true })
remap('i', '<tab>', [[pumvisible() ? "<c-n>" : "<tab>"]], { expr = true, noremap = true })
remap('i', '<s-tab>', [[pumvisible() ? "<c-p>" : "<bs>"]], { expr = true, noremap = true })

npairs.setup({ check_ts = true, map_bs = true, map_cr = true })

vim.g.coq_settings = { keymap = { recommended = false } }

-- skip it, if you use another global object
_G.MUtils= {}

MUtils.CR = function()
    if vim.fn.pumvisible() ~= 0 then
        if vim.fn.complete_info({ 'selected' }).selected ~= -1 then
            return npairs.esc('<c-y>')
        else
            return npairs.esc('<c-e>') .. npairs.autopairs_cr()
        end
    else
        return npairs.autopairs_cr()
    end
end
remap('i', '<cr>', 'v:lua.MUtils.CR()', { expr = true, noremap = true })

MUtils.BS = function()
    if vim.fn.pumvisible() ~= 0 and vim.fn.complete_info({ 'mode' }).mode == 'eval' then
        return npairs.esc('<c-e>') .. npairs.autopairs_bs()
    else
        return npairs.autopairs_bs()
    end
end
remap('i', '<bs>', 'v:lua.MUtils.BS()', { expr = true, noremap = true })

local move_func_same = function()
    return function(opts)
        if opts.next_char == opts.char then
            if opts.col == string.len(opts.line) then
                return
            end
            -- ("|")  => (""|)
            --  ""       |"      "  => ""       "|      "
            if utils.is_in_quotes(opts.line, opts.col - 1, opts.char) then
                return
            end
        end
        return false
    end
end

local count_paired = function()
    return function(opts)
        local line = opts.line
        local count = 0
        local idx = 1
        while idx <= string.len(line) do
            if line:sub(idx, idx) == '$' and (idx == 0 or line:sub(idx-1, idx-1) ~= '\\') then
                print(idx)
                count = count + 1
            end
            idx = idx + 1
        end

        if count % 2 == 1 then
            return false
        end
    end
end

local default = {
    map_bs = true,
    map_c_h = false,
    map_c_w = false,
    map_cr = true,
    disable_filetype = { 'TelescopePrompt', 'spectre_panel' },
    disable_in_macro = false,
    disable_in_visualblock = false,
    ignored_next_char = [=[[%w%%%'%[%"%.]]=],
    break_undo = true,
    check_ts = false,
    enable_moveright = true,
    enable_afterquote = true,
    enable_check_bracket_line = true,
    enable_bracket_in_quote = true,
    enable_abbr = false,
    ts_config = {
        lua = { 'string', 'source' },
        javascript = { 'string', 'template_string' },
    },
}

local is_char = function (char, match_char)
    return char == match_char;
end

local is_in_pair = function (line, pos, match_char, quote_type)
    local cIndex = 0
    local result = false
    local last_char = quote_type or ''

    while cIndex < string.len(line) and cIndex < pos  do
        cIndex = cIndex + 1
        local char = line:sub(cIndex, cIndex)
        if
            result == true and
            char == last_char and
            line:sub(cIndex -1, cIndex -1) ~= "\\"
        then
            result = false
            last_char = quote_type or ''
        elseif result == false and is_char(char, match_char)
            and (not quote_type or char == quote_type)
        then
            last_char = quote_type or char
            result = true
        end
    end
    return result
end

local move_right = function(match_char)
    return function(opts)
        if opts.next_char == opts.char then
            if utils.is_close_bracket(opts.char) then
                return
            end
            -- move right when have quote on end line or in quote
            -- situation  |"  => "|
            if is_char(opts.char, match_char) then
                if opts.col == string.len(opts.line) then
                    return
                end
                -- ("|")  => (""|)
                --  ""       |"      "  => ""       "|      "
                if is_in_pair(opts.line, opts.col - 1, match_char, opts.char) then
                    return
                end
            end
        end
        return false
    end
end

local not_add_char_inside_char = function(match_char)
    return function(opts)
        if is_char(opts.char, match_char)
            and is_in_pair(opts.text, opts.col - 1, match_char)
        then
            return false
        end
    end
end

local move_func = function(match_char)
    return default.enable_moveright and move_right(match_char) or cond.none
end

local basic = function(...)
    local rule = Rule(...)

    if #default.ignored_next_char > 1 then
        rule:with_pair(cond.not_after_regex(default.ignored_next_char))
    end
    rule:use_undo(default.break_undo)
    return rule
end

local bracket = function(...)
    local rule = basic(...)
    if default.enable_check_bracket_line == true then
        rule
            :with_pair(cond.is_bracket_line())
            :with_move(cond.is_bracket_line_move())
    end
    if default.enable_bracket_in_quote then
        -- still add bracket if text is quote "|" and next_char have "
        rule:with_pair(cond.is_bracket_in_quote(), 1)
    end
    return rule
end


npairs.add_rules({
    basic("$", "$", {"tex", "latex"})
        :with_pair(cond.not_before_regex("%w"))
        :with_move(move_func)
        :with_pair(not_add_char_inside_char("$")),
    bracket("\\[", "\\]", {"tex", "latex"})
})

--    Rule("\\[", "\\]", {"tex", "latex"}),
--    Rule("$", "$", {"tex", "latex"})
--        :with_pair(cond.not_before_regex("\\", 1))
--        :with_pair(cond.not_inside_quote())
--        :with_pair(cond.not_after_regex(npairs.config.ignored_next_char))
--        --:with_pair(ts_conds.is_not_ts_node_comment)
--        --:with_pair(ts_conds.is_not_ts_node({'string','comment'}))
--        :with_pair(count_paired())
--        :with_move(move_func_same())
--        :use_undo(true)
--})

