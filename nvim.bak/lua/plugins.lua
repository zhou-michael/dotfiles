require('packer').startup(function()
    use 'wbthomason/packer.nvim'

    ----------
    --- UI ---
    ----------
    use { 'catppuccin/nvim', as = 'catppuccin' }
    use 'bluz71/vim-moonfly-colors'
    use 'mhartington/oceanic-next'
    use 'connorholyday/vim-snazzy'
    use 'folke/tokyonight.nvim'
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    use 'nvim-treesitter/nvim-treesitter-context'
    use 'nvim-treesitter/playground'
    --use 'datwaft/bubbly.nvim'
    use 'nvim-lualine/lualine.nvim'
    use 'kyazdani42/nvim-web-devicons'
    use 'lukas-reineke/indent-blankline.nvim'
    use 'norcalli/nvim-colorizer.lua'
    use 'folke/twilight.nvim'


    -----------
    --- LSP ---
    -----------
    use 'neovim/nvim-lspconfig'
    use 'simrat39/rust-tools.nvim'
    use 'folke/lsp-colors.nvim'
    use 'nvim-lua/lsp-status.nvim'
    use 'glepnir/lspsaga.nvim'
    use {
        'williamboman/mason.nvim',
        requires = {
            'neovim/nvim-lspconfig',
        },
    }
    use 'williamboman/mason-lspconfig.nvim'
    --use 'williamboman/nvim-lsp-installer'


    -------------
    --- utils ---
    -------------
    use 'windwp/nvim-autopairs'
    use 'tpope/vim-fugitive'
    use 'lewis6991/gitsigns.nvim'


    ----------------------
    --- powerful stuff ---
    ----------------------
    use {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.0',
        requires = { {'nvim-lua/plenary.nvim'} }
    }
    use 'nvim-telescope/telescope-file-browser.nvim'
    use 'ellisonleao/glow.nvim'
    use 'kyazdani42/nvim-tree.lua'
    use 'lervag/vimtex'
    use 'SirVer/ultisnips'


    ----------------
    --- nvim-cmp ---
    ----------------
    use "hrsh7th/nvim-cmp"
    use "hrsh7th/cmp-buffer"
    use "hrsh7th/cmp-path"
    use "hrsh7th/cmp-cmdline"
    use "hrsh7th/cmp-nvim-lsp"
    use "hrsh7th/cmp-nvim-lua"
    use 'quangnguyen30192/cmp-nvim-ultisnips'


    use 'zhou-michael/cpp-javadoc'
    ----------------------
    --- Unused plugins ---
    ----------------------
--    use 'ms-jpq/coq.nvim'
--    use { 'ms-jpq/coq.artifacts', branch = 'artifacts' }
end)

require('config')

--require('plugin_config.colorscheme')
--require('plugin_config.treesitter')
--require('plugin_config.nvim_lsp_installer')
--require('plugin_config.coq')
--require('plugin_config.bubbly')
--require('plugin_config.nvim_autopairs')
--require('plugin_config.glow')
--require('plugin_config.nvim_tree')
--require('plugin_config.spellsitter')

--local saga = require 'lspsaga'
--saga.init_lsp_saga()

