vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

opt.termguicolors = true -- 24-bit RGB color

opt.number = true -- absolute line number (for current line)
opt.relativenumber = true -- relative line numbers
opt.signcolumn = "yes" -- display sign column

opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
-- opt.foldcolumn = "auto:1" -- show up to one column of fold signs
opt.foldenable = true -- don't fold when opening file
opt.foldlevel = 20

opt.scrolloff = 1 -- always display 1 row above/below cursor
opt.sidescrolloff = 8 -- display 8 columns left and right of cursor

opt.conceallevel = 2 -- hide concealed characters unless replacement character exists

opt.tabstop = 4 -- 4 space tabs
opt.shiftwidth = 4 -- indent size
opt.shiftround = true -- round indent to multiple of shiftwidth
opt.expandtab = true -- expands tabs into spaces
opt.textwidth = 100 -- max line width

opt.autoindent = true -- continue indents on newline
opt.smartindent = true -- indent after braces

opt.wrap = false -- lines don't wrap
opt.breakindent = true -- wrapped lines are visually indented

opt.spell = true -- enable spellcheck
opt.spelllang = { "en_us", "cjk" } -- spellcheck language

opt.ignorecase = true -- ignore case
opt.smartcase = true -- don't ignore case when there is a capital in the search pattern

opt.splitbelow = true -- default split below
opt.splitkeep = "screen" -- keep screen level when splitting
opt.splitright = true

opt.formatoptions = "jcroqlnt"

opt.undofile = true -- save undo history to file
opt.undolevels = 500 -- number of undo changes

opt.timeoutlen = 150 -- time in milliseconds to complete mapped sequence
opt.confirm = true -- confirm write when exiting

opt.pumblend = 10 -- transparency of popup menu

opt.showmode = false -- don't show insert/normal mode

-- grep and vimgrep, wildmode ?

-- Python path
-- vim.g.python3_host_prog = "/opt/homebrew/bin/python3"

-- coq
vim.g.coq_settings = {
    auto_start = 'shut-up'
}
