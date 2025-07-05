local util = require("b2.utils")

TMUX_MODES = { "window", "pane_v", "pane_h", "pane_full" };

local function get_tmux_mode()
    local file = io.open(os.getenv("HOME") .. "/.config/nvim/tmux-mode.txt", "r")
    if file then
        local content = file:read("*l")
        file:close()
        return content
    end
    return "window"
end

function SetTmuxMode(mode)
    if util.contains(TMUX_MODES, mode) then
        local file = io.open(os.getenv("HOME") .. "/.config/nvim/tmux-mode.txt", "w")
        if file then
            file:write(mode)
            file:close()
            print("Set tmux mode to " .. mode)
        end
    else
        vim.notify("Mode \"" .. mode .. "\" is unknown, try: " .. util.pretty_string(TMUX_MODES), vim.log.levels.ERROR)
    end
end

local function open_tmux_window(window_id, command)
    vim.fn.system(string.format(
        'tmux send-keys -t %s "%s ; echo Press Enter to close...; read; tmux kill-window" Enter',
        window_id, command
    ))
end
local function open_tmux_pane(pane_id, command)
    vim.fn.system(string.format(
        'tmux send-keys -t %s "%s ; echo Press Enter to close...; read; tmux kill-pane" Enter',
        pane_id, command
    ))
end

vim.keymap.set("n", "<leader>r", function()
    local key = vim.fn.getcharstr()
    local filetype = vim.bo.filetype
    local in_tmux = string.gsub(vim.fn.system("echo $TERM_PROGRAM"), "%s+", "") == "tmux"

    -- * {input}    - prompts the user for input (doesn't move the cursor to the position of {input})
    --
    -- replace - with
    -- * {abspath}  - absolute path
    -- * {filepath} - relative path
    -- * {basename} - relative path (with out extentions)
    -- * {ext}      - extention
    local config = {
        [{ "rust" }] = {
            r = "cargo run",         -- run command
            b = "cargo build",       -- build command
            t = "cargo test",        -- test command
            c = "{input}",           -- default preset
            i = "cargo add {input}", -- install preset
        },
        [{ "python" }] = {
            r = "uv run {filepath}", -- run command
            b = "{input}",           -- build command
            t = "{input}",           -- test command
            c = "{input}",           -- default preset
            i = "uv add {input}",    -- install preset
        },
        [{ "c" }] = {
            r = "make {basename} && {basename} {input}",
        }
    }

    local commands = util.getByPartialKey(config, filetype)
    local command

    if not commands then
        if key == "c" then
            command = "{input}"
        else
            vim.notify(string.format("No commands for file type %s found! (use <leader>rc)", filetype), vim.log.levels.ERROR)
            return
        end
    else
        command = commands[key]
        if command == nil and key == "c" then
            command = "{input}"
        end
    end

    if not command then
        vim.notify(string.format('No action for key "%s" found!', key), vim.log.levels.ERROR)
        return
    elseif command:find("{input}") then
        command = vim.fn.input({ prompt = "Change Command Preset: ", default = command:gsub("{input}", "") })
        if not command or command == "" then
            vim.notify("No command provided", vim.log.levels.ERROR)
            return
        end
    end

    if command:find("{abspath}") ~= nil then
        local abspath = vim.fn.expand('%:p')
        command = command:gsub("{abspath}", abspath)
    end
    if command:find("{filepath}") ~= nil then
        local filepath = vim.fn.expand('%:p:.')
        command = command:gsub("{filepath}", filepath)
    end
    if command:find("{basename}") ~= nil then
        local basename = vim.fn.expand('%:r')
        command = command:gsub("{basename}", "./" .. basename)
    end
    if command:find("{ext}") ~= nil then
        local ext = vim.fn.expand('%:e')
        command = command:gsub("{ext}", ext)
    end

    -- escape quotes
    command = command:gsub("\\\"", "\\\\\"")
    command = command:gsub("\"", "\\\"")
    command = command:gsub("!", "\\!");

    local tmux_mode = get_tmux_mode()

    print("Run command (" .. tmux_mode .. "): " .. command)

    local tmux_modes = {
        pane_full = function()
            local pane_id = vim.fn.system("tmux split-window -h -P -F '#{pane_id}'"):gsub("%s+", "")
            if pane_id and pane_id ~= "" then
                vim.fn.system(string.format('tmux resize-pane -Z'))
                open_tmux_pane(pane_id, command)
            else
                vim.notify("Failed to create a pane...", vim.log.levels.ERROR)
            end
        end,
        pane_v = function()
            local pane_id = vim.fn.system("tmux split-window -h -P -F '#{pane_id}'"):gsub("%s+", "")
            if pane_id and pane_id ~= "" then
                open_tmux_pane(pane_id, command)
            else
                vim.notify("Failed to create a pane...", vim.log.levels.ERROR)
            end
        end,
        pane_h = function()
            local pane_id = vim.fn.system("tmux split-window -v -P -F '#{pane_id}'"):gsub("%s+", "")
            if pane_id and pane_id ~= "" then
                open_tmux_pane(pane_id, command)
            else
                vim.notify("Failed to create a pane...", vim.log.levels.ERROR)
            end
        end,
        window = function()
            local window_id = vim.fn.system("tmux new-window -P -F '#{window_id}'"):gsub("%s+", "")
            if window_id and window_id ~= "" then
                open_tmux_window(window_id, command)
            else
                vim.notify("Failed to create a window...", vim.log.levels.ERROR)
            end
        end,
    }

    if in_tmux then
        if tmux_modes[tmux_mode] == nil then
            vim.notify("tmux_mode " .. tmux_mode .. " unknown", vim.log.levels.ERROR)
        else
            tmux_modes[tmux_mode]()
        end
    else
        -- vim.cmd(string.format("term bash -c '%s ; echo Press Enter to close...; read'", command))
        print(
            "1. Make sure you're in a tmux session\n2. Make sure the environment variable $TERM_PROGRAM is set to tmux")
    end
end)
