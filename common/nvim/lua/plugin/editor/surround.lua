-- nvim-surround: ys{motion}{char} to surround, cs{old}{new} to change, ds{char} to delete.
-- Works alongside nvim-autopairs without conflict:
--   autopairs fires reactively on insertion; surround operates on existing text in normal mode.
return {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {},
}
