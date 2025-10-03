vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.winborder = "single"
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.wrap = false
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.colorcolumn = "79"
vim.opt.ignorecase = true
vim.opt.signcolumn = "yes"

local map = vim.keymap.set
vim.g.mapleader = " "

map("i", "<C-L>", "<C-O><C-L>")

map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzz")
map("n", "N", "Nzz")

map({ "n", "v", "x" }, "<leader>y", "\"+y")
map({ 'n', 'v', 'x' }, '<leader>d', '\"_d')
map({ "n", "v", "x" }, "<leader>c", "\"_c")

map('n', '<leader>s', ':e #<CR>')

map({ 'n', 'v' }, '<leader>cw', '1z=')
map("n", "<leader>e", vim.cmd.Ex)

map('n', '<leader>cn', ':cnext<CR>')
map('n', '<leader>cp', ':cprev<CR>')
map('n', '<leader>cc', ':cclose<CR>')
map('n', '<leader>co', ':copen<CR>')

map('n', '<leader>n', ':next<CR>')
map('n', '<leader>p', ':prev<CR>')

-- plugins
vim.pack.add({
	{ src = "https://github.com/vague2k/vague.nvim" },
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
map('n', '<leader>f', ':Pick files tool=\'rg\'<CR>')
map('n', '<leader>h', ':Pick help tool=\'rg\'<CR>')
map('n', '<leader>g', ':Pick grep tool=\'rg\'<CR><CR>')
map('n', '<leader>lg', ':Pick grep_live tool=\'rg\'<CR>')

require("nvim-treesitter.configs").setup({ highlight = { enable = true } })

-- colorscheme
vim.cmd('colorscheme vague')
vim.cmd('hi statusline guibg=NONE')
