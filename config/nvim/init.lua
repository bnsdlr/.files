-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

local function contains(t, value)
    for _, v  in pairs(t) do
        if v == value then
            return true
        end
    end
    return false
end

vim.opt.nu = true
vim.opt.number = true
vim.opt.relativenumber = true

vim.api.nvim_create_autocmd('FileType', {
    desc = 'File type specific settings',
    callback = function(filetype)
        local ext = filetype.match

        if contains({ 'nix', 'markdown' }, ext) then
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

vim.opt.smartindent = true

vim.opt.swapfile = false
vim.opt.directory = os.getenv("HOME") .. "/.vim/tmp/swap//" -- Custom swap file location

vim.opt.backup = true
vim.opt.backupdir = os.getenv("HOME") .. "/.vim/tmp/backup//" -- Custom backup directory

vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.wrap = false

vim.opt.termguicolors = true

vim.opt.scrolloff = 8

vim.opt.updatetime = 250

vim.opt.colorcolumn = "80"

vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"

vim.opt.ignorecase = true

-- Remaps
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

require "run"

-- Setup lazy.nvim
require "lazy" .setup({
    spec = { import = "plugins" },
    change_detection = { notify = false },
})
