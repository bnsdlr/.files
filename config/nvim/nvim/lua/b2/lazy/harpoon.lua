-- ~/.local/share/nvim
return {
    "ThePrimeagen/harpoon",
    config = function()
        require("harpoon").setup({})
        vim.keymap.set("n", "<leader>a", function() require("harpoon.mark").add_file() end)
        vim.keymap.set("n", "<C-e>", function() require("harpoon.ui").toggle_quick_menu() end)

        vim.keymap.set("n", "<C-h>", function() require("harpoon.ui").nav_file(1) end)
        vim.keymap.set("n", "<C-t>", function() require("harpoon.ui").nav_file(2) end)
        vim.keymap.set("n", "<C-n>", function() require("harpoon.ui").nav_file(3) end)
        vim.keymap.set("n", "<C-s>", function() require("harpoon.ui").nav_file(4) end)

        -- Toggle previous & next buffers stored within Harpoon list
        vim.keymap.set("n", "<C-S-P>", function() require("harpoon.ui").nav_prev() end)
        vim.keymap.set("n", "<C-S-N>", function() require("harpoon.ui").nav_next() end)
    end,
}
