local key_config = {
    r = "run",
    b = "build",
    t = "test",
    i = "install",
    c = "custom",
}

-- * {input}    - prompts the user for input (doesn't move the cursor to the position of {input})
--
-- replace - with
-- * {abspath}  - absolute path
-- * {filepath} - relative path
-- * {basename} - absolute path (with out extentions)
-- * {ext}      - extention
local config = {
    [{ "rust" }] = {
        run = "cargo run",
        build = "cargo build",
        test = "cargo test",
        install = "cargo add {input}",
        is_standalone = function()
            return vim.fn.findfile("Cargo.toml", ".;") == "" -- search for Cargo.toml in parent dirs
        end,
        standalone_conf = {
            run = "rustc {filepath} -o {basename} && {basename}",
            build = "rustc {filepath} -o {basename}",
            test = "rustc {filepath} -o {basename} --test && {basename}",
        }
    },
    [{ "python" }] = {
        run = "uv run {filepath}",
        build = "{input}",
        test = "{input}",
        install = "uv add {input}",
    },
    [{ "c" }] = {
        run = "make",
        build = "make build",
        is_standalone = function()
            return vim.fn.findfile("Makefile", ".;") == ""
        end,
        standalone_conf = {
            run = "gcc -Wall -Werror -o {input}",
        }
    }
}

local replace = {
    ["{abspath}"] = function() vim.fn.expand('%:p') end,
    ["{filepath}"] = function() vim.fn.expand('%:p:.') end,
    ["{basename}"] = function() vim.fn.expand('%:r') end,
    ["{ext}"] = function() vim.fn.expand('%:e') end,
    -- escape
    ["\\\""] = "\\\\\"",
    ["\""] = "\\\"",
    ["!"] = "\\!",
}

local function get_from_table(t, key)
    for k, v in pairs(t) do
        if type(k) == "table" then
            for _, v2 in ipairs(k) do
                if v2 == key then
                    return v
                end
            end
        else
            if k == key then
                return v
            end
        end
    end
end

vim.keymap.set("n", "<leader>r", function()
    local key = vim.fn.getcharstr()
    local filetype = vim.bo.filetype
    local in_tmux = string.gsub(vim.fn.system("echo $TERM_PROGRAM"), "%s+", "") == "tmux"

    local commands = get_from_table(config, filetype)

    if commands.standalone_conf ~= nil and commands.is_standalone ~= nil then
        if commands.is_standalone() then
            commands = commands.standalone_conf
        end
    end

    local command

    if not commands then
        if key == "c" then
            command = "{input}"
        else
            vim.notify(string.format("No commands for file type %s found! (use <leader>rc)", filetype),
                vim.log.levels.ERROR)
            return
        end
    else
        command = commands[key_config[key]]
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

    print(type(replace))

    for k, v in pairs(replace) do
        if command:find(k) ~= nil then
            if type(v) == "function" then
                command = command:gsub(k, v())
            elseif type(v) == "string" then
                command = command:gsub(k, v)
            else
                vim.notify("Did not expect type " .. type(v))
            end
        end
    end

    if in_tmux then
        local window_id = vim.fn.system("tmux new-window -P -F '#{window_id}'"):gsub("%s+", "")
        if window_id and window_id ~= "" then
            vim.fn.system(string.format(
                'tmux send-keys -t %s "%s ; echo Press Enter to close...; read; tmux kill-window" Enter',
                window_id, command
            ))
        else
            vim.notify("Failed to create a window...", vim.log.levels.ERROR)
        end
    else
        -- vim.cmd(string.format("term bash -c '%s ; echo Press Enter to close...; read'", command))
        print(
            "1. Make sure you're in a tmux session\n2. Make sure the environment variable $TERM_PROGRAM is set to tmux")
    end
end)
