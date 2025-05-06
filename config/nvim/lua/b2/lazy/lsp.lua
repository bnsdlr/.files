return {
    'williamboman/mason.nvim',
    build = ":MasonUpdate",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        'neovim/nvim-lspconfig',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/nvim-cmp',
        'hrsh7th/cmp-cmdline',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
    },
    config = function()
        -- Reserve a space in the gutter
        vim.opt.signcolumn = 'yes'

        -- Add cmp_nvim_lsp capabilities settings to lspconfig
        -- This should be executed before you configure any language server
        local lspconfig_defaults = require('lspconfig').util.default_config
        lspconfig_defaults.capabilities = vim.tbl_deep_extend(
            'force',
            lspconfig_defaults.capabilities,
            require('cmp_nvim_lsp').default_capabilities()
        )

        -- Mason setup to install and manage LSP servers
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = { "tailwindcss", "rust_analyzer", "eslint", "html", "cssls", "jsonls", "ts_ls", "lua_ls", "bashls" }, -- Add more as needed
            automatic_installation = true,                                                                                           -- Automatically install if not present
            handlers = {
                function(server_name)                                                                                                -- Default handler for servers
                    if server_name ~= "rust_analyzer" then
                        require("lspconfig")[server_name].setup({
                            capabilities = lspconfig_defaults.capabilities
                        })
                    end
                end,

                -- Custom config for ts_ls
                ["ts_ls"] = function()
                    require("lspconfig").ts_ls.setup({
                        capabilities = lspconfig_defaults.capabilities,
                        inti_options = {
                            preferences = {
                                disableSuggestoins = true,
                            }
                        }
                    })
                end,
                -- Custom config for Lua LSP
                ["lua_ls"] = function()
                    require("lspconfig").lua_ls.setup({
                        capabilities = lspconfig_defaults.capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = "Lua 5.1" },
                                diagnostics = {
                                    globals = { "vim" },
                                },
                            },
                        },
                    })
                end,
            },
        })

        -- Autocommands: LSP actions when a server attaches to a buffer
        vim.api.nvim_create_autocmd('LspAttach', {
            desc = 'LSP actions',
            callback = function(event)
                local client = vim.lsp.get_client_by_id(event.data.client_id)
                local opts = { buffer = event.buf }

                local border = "rounded"

                -- specific keymaps
                if client and client.name == "rust_analyzer" then
                    vim.keymap.set('n', 'K', function() vim.cmd.RustLsp({ 'hover', 'actions' }) end, opts)
                    vim.keymap.set('n', '<leader>la', function() vim.cmd.RustLsp('codeAction') end, opts)
                else
                    -- fallback keymaps
                    vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, opts)
                    vim.keymap.set('n', '<leader>la', function() vim.lsp.buf.code_action() end, opts)
                end

                -- styling
                client.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border })
                client.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help,
                    { border = border })
                client.handlers["textDocument/codeAction"] = vim.lsp.with(vim.lsp.handlers.code_action,
                    { border = border })
                client.handlers["window/showMessage"] = function(_, result)
                    local lvl = ({ "ERROR", "WARN", "INFO", "DEBUG" })[result.type]
                    vim.notify(result.message, lvl, { title = client and client.name })
                end

                vim.diagnostic.config {
                    float = { border = border },
                }

                -- global keymaps
                vim.keymap.set('n', 'gD', function() vim.lsp.buf.declaration() end, opts)
                vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, opts)
                vim.keymap.set('n', '<leader>lws', function() vim.lsp.buf.workspace_symbol() end, opts)
                vim.keymap.set('n', '<leader>ld', function() vim.diagnostic.open_float() end, opts)
                vim.keymap.set('n', '<leader>lrn', function() vim.lsp.buf.rename() end, opts)
                vim.keymap.set('n', '<leader>lrr', function() vim.lsp.buf.references() end, opts)
                vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format() end, opts)
                vim.keymap.set('n', 'gi', function() vim.lsp.buf.implementation() end, opts)
                vim.keymap.set('n', 'go', function() vim.lsp.buf.type_definition() end, opts)

                -- insert mode
                vim.keymap.set('i', '<C-h>', function() vim.lsp.buf.signature_help() end, opts)
            end,
        })

        -- nvim-cmp setup for autocompletion
        local cmp = require('cmp')
        cmp.setup({
            snippet = {
                expand = function(args)
                    vim.snippet.expand(args.body) -- Requires Neovim v0.10+
                end,
            },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            mapping = cmp.mapping.preset.insert(),
            sources = {
                { name = 'nvim_lsp' },
                { name = 'buffer' },
            },
        })

        -- cmpline comp
        cmp.setup.cmdline(':', {
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            sources = cmp.config.sources({
                { name = 'path' },
                { name = 'cmdline_history' },
                { name = 'cmdline' },
            }),
            mapping = cmp.mapping.preset.cmdline(),
            formatting = {
                fields = { 'abbr', 'kind' },
            }
        })

        -- search comp
        cmp.setup.cmdline('/', {
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            sources = {
                { name = 'buffer' }
            }
        })

        cmp.setup({
            mapping = {
                ['<Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    else
                        fallback()
                    end
                end, { "i", "s", "c" }),
                ['<S-Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    else
                        fallback()
                    end
                end, { "i", "s", "c" }),
                ['<C-CR>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.confirm()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ['<C-u>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.scroll_docs(-4)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ['<C-d>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.scroll_docs(4)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            }
        })
    end
}
