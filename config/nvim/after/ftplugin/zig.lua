vim.keymap.set({ "n" }, "<leader>lf", function() vim.notify("use <leader>llf", vim.log.levels.INFO) end)
vim.keymap.set({ "n" }, "<leader>llf", vim.lsp.buf.format)
