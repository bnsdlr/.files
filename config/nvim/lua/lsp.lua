require "mason".setup()

vim.lsp.enable({
	"lua_ls",
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
vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition)
vim.keymap.set('n', '<leader>ld', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)
