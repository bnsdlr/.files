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

        if contains({ 'markdown' }, ext) then
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

map({ "n", "v", "x" }, "<leader>d", "\"_d")
map({ "n", "v", "x" }, "<leader>D", "\"_d$")

map({ "n", "v", "x" }, "<leader>c", "\"_c")
map({ "n", "v", "x" }, "<leader>C", "\"_c$")

map({ "n", "v", "x" }, "<leader>S", "\"_c")

map("n", '<leader>s', ':e #<CR>')

map({ 'n', 'v' }, '<leader>c', '1z=')

-- plugins
vim.pack.add({
    { src = "https://github.com/rose-pine/neovim" },
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/echasnovski/mini.pick" },
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/mrcjkb/rustaceanvim" },
    { src = "https://github.com/mbbill/undotree" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
})

require "run"

map("n", "<leader>u", vim.cmd.UndotreeToggle)

require "mason".setup()

require "mini.pick".setup()
map('n', '<leader>pf', ':Pick files tool=\'rg\'<CR>')
map('n', '<leader>ph', ':Pick help tool=\'rg\'<CR>')
map('n', '<leader>pb', ':Pick buffers<CR>')
map('n', '<leader>pg', ':Pick grep tool=\'rg\'<CR> <CR>')

local success, treesitter = pcall(require, 'nvim-treesitter.configs')

if success then
    treesitter.setup({
        ensure_installed = {
            "lua", "vim", "javascript", "typescript", "jsdoc", "bash", "rust",
            "elixir"
        },
        auto_install = true,
        highlight = {
            enable = true,
            disable = function(lang, buf)
                if lang == "html" then
                    print("disabled")
                    return true
                end

                local max_filesize = 100 * 1024 -- 100 KB
                local ok, stats =
                    pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_filesize then
                    vim.notify(
                        "File larger than 100KB treesitter disabled for performance",
                        vim.log.levels.WARN,
                        { title = "Treesitter" }
                    )
                    return true
                end
            end,
        }
    })
else
    vim.notify("Failed to load treesitter", vim.log.levels.WARN,
        { title = "Treesitter" })
end

-- colorscheme
vim.cmd('colorscheme rose-pine')
vim.cmd('hi statusline guibg=NONE')
vim.cmd('hi normal guibg=NONE')

-- lsp
vim.lsp.enable({ "lua_ls" })
vim.cmd('set completeopt+=noselect')

map('n', 'K', function() vim.lsp.buf.hover { max_height = 25, max_width = 120 } end)
map('n', '<leader>lrn', vim.lsp.buf.rename)
map('n', '<leader>lrr', vim.lsp.buf.references)
map('n', '<leader>ps', function() vim.notify("use gO instead", vim.log.levels.WARN) end)
map('n', 'gO', vim.lsp.buf.document_symbol)
map('n', '<leader>la', function() vim.notify("use gra instead", vim.log.levels.WARN) end)
-- CTRL-S (n,s) - vim.lsp.buf.signature_help()
-- [d and ]d move between diagnostics in the current buffer ([D jumps to the first diagnostic, ]D jumps to the last)

-- global keymaps
map('n', 'gd', vim.lsp.buf.definition)
map('n', 'gD', vim.lsp.buf.declaration)
map('n', 'gt', vim.lsp.buf.type_definition)
map('n', '<leader>ld', vim.diagnostic.open_float)
map('n', '<leader>f', vim.lsp.buf.format)
