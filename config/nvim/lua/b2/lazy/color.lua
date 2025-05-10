local function read_scheme()
    local file = io.open(os.getenv("HOME") .. "/.config/nvim/colorscheme.txt", "r")
    if file then
        local scheme = file:read("*l")
        file:close()
        return scheme
    end
    return 'vesper' -- fallback
end

local function save_scheme(scheme)
    local file = io.open(os.getenv("HOME") .. "/.config/nvim/colorscheme.txt", "w")
    if file then
        file:write(scheme)
        file:close()
    end
end

local current_scheme = read_scheme()

function SetColorscheme(scheme_name)
    vim.cmd('colorscheme ' .. scheme_name)
    save_scheme(scheme_name)
    if scheme_name == "catppuccin" then
        require("feline").setup({
            components = require("catppuccin.groups.integrations.feline").get(),
        })
    elseif scheme_name == "bamboo" then
        require('bamboo').load()
    end
end

return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        dependencies = {
            "famiu/feline.nvim"
        },
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                flavour = "mocha",
                transparent_background = true,
                integrations = {
                    cmp = true,
                    gitsigns = true,
                    nvimtree = true,
                    treesitter = true,
                }
            })
        end,
    },
    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            require("rose-pine").setup({
                variant = "main", -- auto, main, moon, or dawn
                dim_inactive_windows = false,
                extend_background_behind_borders = true,

                styles = {
                    bold = true,
                    italic = true,
                    transparency = true,
                },

                -- NOTE: Highlight groups are extended (merged) by default. Disable this
                -- per group via `inherit = false`
                highlight_groups = {
                    -- Comment = { fg = "foam" },
                    -- StatusLine = { fg = "love", bg = "love", blend = 15 },
                    -- VertSplit = { fg = "muted", bg = "muted" },
                    -- Visual = { fg = "base", bg = "text", inherit = false },
                },
            })
        end
    },
    {
        "datsfilipe/vesper.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require('vesper').setup({
                transparent = false,  -- Boolean: Sets the background to transparent
                italics = {
                    comments = true,  -- Boolean: Italicizes comments
                    keywords = true,  -- Boolean: Italicizes keywords
                    functions = true, -- Boolean: Italicizes functions
                    strings = true,   -- Boolean: Italicizes strings
                    variables = true, -- Boolean: Italicizes variables
                },
                overrides = {},       -- A dictionary of group names, can be a function returning a dictionary or a table.
                palette_overrides = {}
            })
            SetColorscheme(current_scheme)
        end,
    },
    {
        'ribru17/bamboo.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            -- Lua
            require('bamboo').setup {
                -- Main options --
                -- NOTE: to use the light theme, set `vim.o.background = 'light'`
                style = 'vulgaris',           -- Choose between 'vulgaris' (regular), 'multiplex' (greener), and 'light'
                transparent = true,           -- Show/hide background
                dim_inactive = false,         -- Dim inactive windows/buffers
                term_colors = true,           -- Change terminal color as per the selected theme style
                cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

                -- Change code style ---
                -- Options are anything that can be passed to the `vim.api.nvim_set_hl` table
                -- You can also configure styles with a string, e.g. keywords = 'italic,bold'
                code_style = {
                    comments = { italic = true },
                    conditionals = { italic = true },
                    keywords = {},
                    functions = {},
                    namespaces = { italic = true },
                    parameters = { italic = true },
                    strings = {},
                    variables = {},
                },

                -- Lualine options --
                lualine = {
                    transparent = true, -- lualine center bar transparency
                },

                -- Custom Highlights --
                colors = {},     -- Override default colors
                highlights = {}, -- Override highlight groups

                -- Plugins Config --
                diagnostics = {
                    darker = false,    -- darker colors for diagnostic
                    undercurl = true,  -- use undercurl instead of underline for diagnostics
                    background = true, -- use background color for virtual text
                },
            }
        end,
    },
}
