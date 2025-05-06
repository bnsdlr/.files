local util = require('b2.utils')

vim.opt.nu = true
vim.opt.number = true
vim.opt.relativenumber = true

vim.api.nvim_create_autocmd('FileType', {
    desc = 'File type specific settings',
    callback = function(filetype)
        local ext = filetype.match

        if util.contains({ 'nix' }, ext) then
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
