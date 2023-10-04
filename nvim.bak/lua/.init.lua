require('plugins')

vim.api.nvim_command('colorscheme catppuccin')

-- general behavior
vim.opt.compatible = false
vim.opt.timeoutlen = 150 -- timeout for multi char commands
vim.opt.spell = true
vim.opt.spelllang = 'en_us'

-- relative number column + set for current line number
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = 'number'

-- indentation
vim.opt.breakindent = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4 -- shouldn't be necessary because of expandtab

-- linebreaks and other related formatting settings
vim.opt.showtabline = 2
vim.opt.wrap = false
vim.opt.scrolloff = 1

-- Setting fold for tex files
local function set_tex_fold()
    vim.opt_local.foldmethod = 'expr'
    vim.opt_local.foldexpr = 'vimtex#fold#level(v:lnum)'
    vim.opt_local.foldtext = 'vimtex#fold#text()'
end

vim.api.nvim_create_autocmd({'BufEnter'}, {
    pattern = '*.tex',
    callback = set_tex_fold
})

-- Customizing highlight groups
local function hi(name, val)
    vim.api.nvim_set_hl(0, name, val)
end

local function set_underline_italic(name)
    hi(name, {
        fg = 'fg',
        bg = 'bg',
        underline = true,
        italic = true
    })
end

if vim.g.colors_name == 'snazzy' then
    set_underline_italic('SpellRare')
    set_underline_italic('SpellEnd')
    set_underline_italic('SpellLocal')
    set_underline_italic('SpellBad')

    hi('CursorLine', {
        fg = 'fg',
        bg = '#303242'
    })

    hi('Folded', {
        fg = '#606580',
        bg = '#303242',
        sp = '#343642',
        bold = true
    })

    hi('Visual', {
        fg = 'fg',
        bg = '#3a3d4d',
        sp = '#3a3d4d'
    })

    vim.g.SnazzyTransparent = 1
elseif vim.g.colors_name == 'catppuccin' then
    hi('Comment', {
        fg = '#686c87',
        bg = 'bg',
        italic = true
    })
    hi('LineNr', {
        fg = '#686c87'
    })
    hi('IndentBlankLineChar', {
        fg = '#646c87'
    })
elseif vim.g.colors_name == 'tokyonight' then
    vim.g.tokyonight_transparent = 1
end

-- tex setup
vim.g.tex_flavor = 'latex'
vim.g.vimtex_view_method = 'skim'
vim.g.vimtex_quickfix_mode = 1
vim.g.vimtex_compiler_latexmk = {build_dir = 'build'}
vim.g.tex_conceal = 'abdmgs'
vim.g.vimtex_view_skim_sync = 1

package.loaded['comment'] = nil
require('comment')
