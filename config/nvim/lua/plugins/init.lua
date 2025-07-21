return {
    -- For telescope
    { "nvim-lua/plenary.nvim" },
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    -- VimBeGood
    { 'ThePrimeagen/vim-be-good' },
    -- For LSP
    { 'neovim/nvim-lspconfig' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/nvim-cmp' },
    { "williamboman/mason-lspconfig.nvim" },
    -- gitsigns
    {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup()
        end
    }
}
