return {
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
        vim.cmd('colorscheme rose-pine')
    end
}
