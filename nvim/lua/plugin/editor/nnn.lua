return {
    "luukvbaal/nnn.nvim",
    lazy = false,
    main = "nnn",
    opts = {
        explorer = {
            cmd = "nnn -AHo",       -- command override (-F1 flag is implied, -a flag is invalid!)
            width = 36,        -- width of the vertical split
            side = "topleft",  -- or "botright", location of the explorer window
            session = "",      -- or "global" / "local" / "shared"
            tabs = true,       -- separate nnn instance per tab
            fullscreen = true, -- whether to fullscreen explorer window when current tab is empty
        },
        picker = {
            cmd = "nnn -AHo",       -- command override (-p flag is implied)
            style = {
                width = 0.9,     -- percentage relative to terminal size when < 1, absolute otherwise
                height = 0.8,    -- ^
                xoffset = 0.5,   -- ^
                yoffset = 0.5,   -- ^
                border = "single"-- border decoration for example "rounded"(:h nvim_open_win)
            },
            session = "",      -- or "global" / "local" / "shared"
            tabs = true,       -- separate nnn instance per tab
            fullscreen = true, -- whether to fullscreen picker window when current tab is empty
        },
        auto_close = true,
    },
    config = function(_, opts)
        local builtin = require("nnn").builtin
        local mappings = {
            { "<C-t>", builtin.open_in_tab },       -- open file(s) in tab
            { "<C-s>", builtin.open_in_split },     -- open file(s) in split
            { "<C-v>", builtin.open_in_vsplit },    -- open file(s) in vertical split
            { "<C-p>", builtin.open_in_preview },   -- open file in preview split keeping nnn focused
            { "<C-y>", builtin.copy_to_clipboard }, -- copy file(s) to clipboard
            { "<C-w>", builtin.cd_to_path },        -- cd to file directory
            { "<C-e>", builtin.populate_cmdline },  -- populate cmdline (:) with file(s)
        }
        opts.mappings = mappings
        require("nnn").setup(opts)
    end,
}
