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
            ensure_installed = { "clangd", "jsonls", "lua_ls", "bashls" }, -- Add more as needed
            automatic_installation = true,                                 -- Automatically install if not present
            handlers = {
                function(server_name)                                      -- Default handler for servers
                    if server_name ~= "rust_analyzer" then
                        require("lspconfig")[server_name].setup({
                            capabilities = lspconfig_defaults.capabilities
                        })
                    end
                end,

                -- Custom config for ts_ls
                -- ["ts_ls"] = function()
                --     require("lspconfig").ts_ls.setup({
                --         capabilities = lspconfig_defaults.capabilities,
                --         inti_options = {
                --             preferences = {
                --                 disableSuggestoins = true,
                --             }
                --         }
                --     })
                -- end,
                ["clangd"] = function()
                    require("lspconfig").clangd.setup({
                        capabilities = lspconfig_defaults.capabilities,
                        cmd = {
                            "clangd",
                            "--background-index",
                            "--background-index-priority=normal", -- low | normal | high
                            "--clang-tidy",
                            "--enable-config",                    -- enable .clangd config files
                            "--header-insertion=never",           -- auto insert missing headers (iwyu | never)
                            "--header-insertion-decorators",
                            "--completion-style=detailed",
                            "--function-arg-placeholders",
                            "--all-scopes-completion",
                        },
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

                -- use defaults
                local builtin = require('telescope.builtin')
                -- grn (n)      - vim.lsp.buf.rename()
                vim.keymap.set('n', '<leader>lrn', function() vim.notify("use grn instead", vim.log.levels.WARN) end,
                    opts)
                -- grr (n)      - vim.lsp.buf.references()
                vim.keymap.set('n', '<leader>lrr', function() vim.notify("use grr instead", vim.log.levels.WARN) end,
                    opts)
                vim.keymap.set('n', 'grr', builtin.lsp_references, opts)
                -- gri (n)      - vim.lsp.buf.implementation()
                vim.keymap.set('n', 'gi', function() vim.notify("use gri instead", vim.log.levels.WARN) end, opts)
                vim.keymap.set('n', 'gri', builtin.lsp_implementations, opts)
                -- gO  (n)      - vim.lsp.buf.document_symbol()
                vim.keymap.set('n', '<leader>ps', function() vim.notify("use gO instead", vim.log.levels.WARN) end, opts)
                vim.keymap.set('n', 'gO', builtin.lsp_document_symbols, opts)
                -- gra (n,v)    - vim.lsp.buf.code_action()
                vim.keymap.set('n', '<leader>la', function() vim.notify("use gra instead", vim.log.levels.WARN) end, opts)
                -- CTRL-S (n,s) - vim.lsp.buf.signature_help()
                -- [d and ]d move between diagnostics in the current buffer ([D jumps to the first diagnostic, ]D jumps to the last)

                -- global keymaps
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts)
                -- vim.keymap.set('n', 'gt', builtin.lsp_type_definitions, opts)
                vim.keymap.set('n', 'go', vim.diagnostic.open_float, opts)
                vim.keymap.set('n', '<leader>ld', function() vim.notify("use go instead", vim.log.levels.WARN) end, opts)
                if not client or client.name ~= "clangd" then
                    vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, opts)
                end

                -- vim.keymap.set('n', 'K', function() vim.lsp.buf.hover { border = border, max_height = 25, max_width = 120 } end, opts)
                -- vim.keymap.set('n', '<leader>lws', vim.lsp.buf.workspace_symbol, opts)
                -- vim.keymap.set('n', '<leader>pw', builtin.lsp_workspace_symbols, opts)
                -- disable format if clangd
            end,
        })

        local ELLIPSIS_CHAR = '…'
        local MAX_LABEL_WIDTH = 120
        local MIN_LABEL_WIDTH = 20

        -- nvim-cmp setup for autocompletion
        local cmp = require('cmp')
        cmp.setup({
            formatting = {
                format = function(entry, vim_item)
                    local label = vim_item.abbr
                    local truncated_label = vim.fn.strcharpart(label, 0, MAX_LABEL_WIDTH)
                    if truncated_label ~= label then
                        vim_item.abbr = truncated_label .. ELLIPSIS_CHAR
                    elseif string.len(label) < MIN_LABEL_WIDTH then
                        local padding = string.rep(' ', MIN_LABEL_WIDTH - string.len(label))
                        vim_item.abbr = label .. padding
                    end
                    return vim_item
                end,
            },
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
