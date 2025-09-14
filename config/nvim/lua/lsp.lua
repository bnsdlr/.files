require "mason".setup()

vim.lsp.enable({
    "lua_ls",
    "elixirls",
	"jsonls",
})

-- vim.api.nvim_create_autocmd('LspAttach', {
--     callback = function(ev)
--         local client = vim.lsp.get_client_by_id(ev.data.client_id)
--         if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
--             vim.opt.completeopt = { 'menu', 'menuone', 'noinsert', 'fuzzy', 'popup' }
--             vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
--             vim.keymap.set('i', '<C-Space>', function()
--                 vim.lsp.completion.get()
--             end)
--         end
--     end,
-- })

require('blink.cmp').setup({
    fuzzy = { implementation = "lua" },
    sources = { default = { 'lsp', 'path', 'buffer' } },
    completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 0 },
        menu = { max_height = 10 }
    },
    keymap = {
        preset = 'default',
        ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
    }
})

vim.keymap.set('n', 'K', function() vim.lsp.buf.hover { max_height = 25, max_width = 120 } end)
vim.keymap.set('n', '<leader>lrn', vim.lsp.buf.rename)
vim.keymap.set('n', '<leader>lrr', vim.lsp.buf.references)
vim.keymap.set('n', '<leader>ps', function() vim.notify("use gO instead", vim.log.levels.WARN) end)
vim.keymap.set('n', 'gO', vim.lsp.buf.document_symbol)
vim.keymap.set('n', '<leader>la', function() vim.notify("use gra instead", vim.log.levels.WARN) end)
-- CTRL-S (n,s) - vim.lsp.buf.signature_help()
-- [d and ]d move between diagnostics in the current buffer ([D jumps to the first diagnostic, ]D jumps to the last)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration)
vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition)
vim.keymap.set('n', '<leader>ld', vim.diagnostic.open_float)

vim.keymap.set('n', '<leader>f', vim.lsp.buf.format)
vim.keymap.set('n', '<leader>lf', "mmGVgo='m")
