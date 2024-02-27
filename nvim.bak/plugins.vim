call plug#begin()
    Plug 'connorholyday/vim-snazzy'
    Plug 'folke/tokyonight.nvim'
    Plug 'lukas-reineke/indent-blankline.nvim'
    Plug 'lervag/vimtex'
    "Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}
    Plug 'tpope/vim-fugitive'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
call plug#end()
