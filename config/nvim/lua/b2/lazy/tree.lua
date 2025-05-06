return {
    cond = false, -- To turn on nvim tree set this to true
    "nvim-tree/nvim-tree.lua",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        {
            'b0o/nvim-tree-preview.lua',
            dependencies = {
                'nvim-lua/plenary.nvim',
                -- '3rd/image.nvim', -- Optional, for previewing images
            },
            -- config = {               -- Uncomment this too for image support
            --     image_preview = {    -- Also read the README on github...
            --         enabled = true,
            --     }
            -- }
        },
    },
    config = function()
        vim.g.nvim_tree_side = "right"
        -- Turn netrw off
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1
        require('nvim-tree').setup {
            view = {
                side = "right",
            },
            on_attach = function(bufnr)
                local api = require('nvim-tree.api')

                vim.keymap.set('n', '<leader>pt', function()
                    if api.tree.is_visible then
                        api.tree.close()
                    else
                        api.tree.open()
                    end
                end)
                api.config.mappings.default_on_attach(bufnr)

                local function opts(desc)
                    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
                end

                local preview = require('nvim-tree-preview')

                vim.keymap.set('n', 'P', preview.watch, opts 'Preview (Watch)')
                vim.keymap.set('n', '<Esc>', preview.unwatch, opts 'Close Preview/Unwatch')
                vim.keymap.set('n', '<C-f>', function() return preview.scroll(4) end, opts 'Scroll Down')
                vim.keymap.set('n', '<C-b>', function() return preview.scroll(-4) end, opts 'Scroll Up')

                -- Option A: Smart tab behavior: Only preview files, expand/collapse directories (recommended)
                vim.keymap.set('n', '<Tab>', function()
                    local ok, node = pcall(api.tree.get_node_under_cursor)
                    if ok and node then
                        if node.type == 'directory' then
                            api.node.open.edit()
                        else
                            preview.node(node, { toggle_focus = true })
                        end
                    end
                end, opts 'Preview')

                -- Option B: Simple tab behavior: Always preview
                -- vim.keymap.set('n', '<Tab>', preview.node_under_cursor, opts 'Preview')
            end,
        }
    end
}
