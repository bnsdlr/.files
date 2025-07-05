vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set("n", "<leader>pv", function() vim.cmd.Ex() end)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- better indent
vim.keymap.set("v", "<", "<gv4h")
vim.keymap.set("v", ">", ">gv4l")

-- Scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz") -- down
vim.keymap.set("n", "<C-u>", "<C-u>zz") -- up
vim.keymap.set("n", "<C-ö>", "20zh")    -- left
vim.keymap.set("n", "<C-ü>", "20zl")    -- right

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+y$")
vim.keymap.set("v", "<leader>y", "\"+y")

vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("n", "<leader>D", "\"+d$")
vim.keymap.set("v", "<leader>d", "\"_d")

vim.keymap.set("n", "<leader>c", "\"_c")
vim.keymap.set("n", "<leader>C", "\"+c$")
vim.keymap.set("v", "<leader>c", "\"_c")

vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
