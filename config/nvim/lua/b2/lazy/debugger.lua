return {
    'mfussenegger/nvim-dap',
    dependencies = {
        'rcarriga/nvim-dap-ui',
        'theHamsta/nvim-dap-virtual-text',
        'nvim-neotest/nvim-nio',
    },
    config = function()
        local dap = require("dap")
        local ui = require("dapui")

        vim.keymap.set('n', 'öc', dap.continue)
        vim.keymap.set('n', 'ön', dap.step_over)
        vim.keymap.set('n', 'öi', dap.step_into)
        vim.keymap.set('n', 'öo', dap.step_out)
        vim.keymap.set('n', 'öb', dap.step_back)
        vim.keymap.set('n', 'örr', dap.restart)
        vim.keymap.set('n', '<Leader>b', dap.toggle_breakpoint)
        vim.keymap.set('n', 'öro', dap.repl.open)
        vim.keymap.set('n', 'öl', dap.run_last)
        vim.keymap.set('n', 'öt', dap.terminate)

        vim.keymap.set('n', '<leader>?', function()
            require('dapui').eval(nil, { enter = true })
        end)

        dap.listeners.before.attach.dapui_config = function()
            ui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            ui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            ui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            ui.close()
        end

        require('dapui').setup();
        require("nvim-dap-virtual-text").setup()
    end
}
