return {
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
        disabled_keys = {
            ["gg"] = { "n" },
        },
        ["gg"] = {
            message = function()
               return "Use go instead of gg"
            end,
            length = 2,
        },
    }
}
