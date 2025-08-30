local function contains(t, value)
    for _, v in pairs(t) do
        if v == value then
            return true
        end
    end
    return false
end

vim.api.nvim_create_autocmd('FileType', {
    desc = 'File type specific settings',
    callback = function(filetype)
        local ext = filetype.match

        if contains({ 'markdown', 'elixir' }, ext) then
            vim.opt.tabstop = 2
            vim.opt.softtabstop = 2
            vim.opt.shiftwidth = 2
            vim.opt.expandtab = true
        else
            vim.opt.tabstop = 4
            vim.opt.softtabstop = 4
            vim.opt.shiftwidth = 4
            vim.opt.expandtab = true
        end
    end,
})

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.winborder = "single"

vim.opt.smartindent = true

vim.opt.swapfile = false
-- vim.opt.directory = os.getenv("HOME") .. "/.vim/tmp/swap//" -- Custom swap file location

vim.opt.backup = true
vim.opt.backupdir = os.getenv("HOME") .. "/.vim/tmp/backup//"

vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.wrap = false

vim.opt.termguicolors = true

vim.opt.scrolloff = 8

vim.opt.colorcolumn = "79"

vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = "yes"

-- Remaps
vim.g.mapleader = " "

local map = vim.keymap.set

map("n", "<leader>pv", function() vim.cmd.Ex() end)

map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

map("n", "<C-d>", "<C-d>zz") -- down
map("n", "<C-u>", "<C-u>zz") -- up

map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

map({ "n", "v", "x" }, "<leader>y", "\"+y")
map({ "n", "v", "x" }, "<leader>Y", "\"+y$")

map({ 'n', 'v', 'x' }, '<leader>d', '\'_d')
map({ 'n', 'v', 'x' }, '<leader>D', '\'_d$')

map({ "n", "v", "x" }, "<leader>S", "\"_cc")

map('n', '<leader>s', ':e #<CR>')

map({ 'n', 'v' }, '<leader>cw', '1z=')

map('n', '<leader>cn', ':cnext<CR>')
map('n', '<leader>cp', ':cprev<CR>')
map('n', '<leader>cc', ':cclose<CR>')
map('n', '<leader>co', ':copen<CR>')
map('n', '<leader>cf', [[:vimgrep /\<<C-r><C-w>\>/ **/*<CR>]])

-- plugins
vim.pack.add({
    { src = "https://github.com/rose-pine/neovim" },
    { src = "https://github.com/echasnovski/mini.pick" },
    { src = "https://github.com/mbbill/undotree" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
    -- lsp
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = 'https://github.com/Saghen/blink.cmp' },
    -- language plugins
    { src = "https://github.com/mrcjkb/rustaceanvim" },
})

require "run"
require "lsp"

map("n", "<leader>u", vim.cmd.UndotreeToggle)

require "mini.pick".setup()
map('n', '<leader>pf', ':Pick files tool=\'rg\'<CR>')
map('n', '<leader>ph', ':Pick help tool=\'rg\'<CR>')
map('n', '<leader>pb', ':Pick buffers<CR>')
map('n', '<leader>pg', ':Pick grep tool=\'rg\'<CR> <CR>')

require("nvim-treesitter.configs").setup({ highlight = { enable = true } })

-- colorscheme
vim.cmd('colorscheme rose-pine')
vim.cmd('hi statusline guibg=NONE')
