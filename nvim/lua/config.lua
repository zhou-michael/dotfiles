require('plugins')
--require('key_bindings')

--------------------------
--- colorscheme config ---
--------------------------

vim.g.moonflyTransparent = 1

local catppuccin = require("catppuccin")
catppuccin.setup({ transparent_background = true })

-------------------------
--- Treesitter config ---
-------------------------
local configs = require('nvim-treesitter.configs')
configs.setup {
    ensure_installed = "maintained",
    highlight = {
        enable = true,
        disable = {"latex"}
    },
    indent = {
        enable = true,
        disable = {"python"}
    }
}

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

----------------------------
--- LSP Installer config ---
----------------------------
local lsp_installer = require("nvim-lsp-installer")
lsp_installer.on_server_ready(function(server)
    local opts = {}
    if server.name == "sumneko_lua" then
        opts = {
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { 'vim', 'use' }
                    }
                }
            }
        }
    end
    server:setup(opts)
end)

------------------
--- COQ config ---
------------------
vim.g.coq_settings = {
    auto_start = 'shut-up'
}

require("coq_3p") {
    { src = "vimtex", short_name = "vTEX" },
}

---------------------
--- Bubbly config ---
---------------------
vim.g.bubbly_palette = {
    background = "Normal background",
    foreground = "#272935",
    black = "#3e4249",
    red = "#ec7279",
    green = "#a0c980",
    yellow = "#deb974",
    blue = "#6cb6eb",
    purple = "#d38aea",
    cyan = "#5dbbc1",
    white = "#c5cdd9",
--    lightgrey = "#57595e",
    lightgrey = "#747a8a",
--    darkgrey = "#404247",
    darkgrey = "#57595e",
}
vim.g.bubbly_statusline = {
    'mode',

    'truncate',

    'path',
    'branch',
    --'builtinlsp.diagnostic_count',
    --'builtinlsp.current_function',

    'divisor',

    'filetype',
    'progress',
}
vim.g.bubbly_characters = {
    close = ''
}
vim.g.bubbly_colors = {
    mode = {
        normal = { background = 'green', foreground = 'foreground' },
        insert = { background = 'blue', foreground = 'foreground' },
        visual = { background = 'red', foreground = 'foreground' },
        visualblock = { background = 'red', foreground = 'foreground' },
        command = { background = 'red', foreground = 'foreground' },
        terminal = { background = 'blue', foreground = 'foreground' },
        replace = { background = 'yellow', foreground = 'foreground' },
        default = { background = 'white', foreground = 'foreground' }
    },
    path = {
        path = { background = 'white', foreground = 'foreground' },
    },
    branch = { background = 'purple', foreground = 'foreground' },
    filetype = { background = 'blue', foreground = 'foreground' },
    tabline = {
        active = { background = 'blue', foreground = 'foreground' },
        inactive = { background = 'white', foreground = 'foreground' },
    }
}

------------------------
--- Autopairs config ---
------------------------
--local Rule = require('nvim-autopairs.rule')
--local npairs = require('nvim-autopairs')
--local cond = require('nvim-autopairs.conds')
--
--npairs.setup()
--
--npairs.add_rules({
--    Rule("$", "$", {"tex", "latex"})
--        :with_pair(cond.not_before_regex("\\"))
--        :with_move()
--    }
--)

---------------------------
--- spellchecker config ---
---------------------------

require('spellsitter').setup()

