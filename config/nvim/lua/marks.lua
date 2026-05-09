local M = {}

M.map = function(t)
	for key, char in pairs(t) do
		vim.keymap.set({ "n" }, "m<C-" .. key .. ">", "m" .. char)
		vim.keymap.set({ "n" }, "<C-" .. key .. ">", "'" .. char)
	end
end

local function find_buf(path)
    if not path or path == "" then return nil end
    local full_path = vim.fn.fnamemodify(path, ":p")
    local bufnr = vim.fn.bufadd(full_path)
    vim.fn.bufload(bufnr)
    return bufnr
end

local function parse_line(line)
    local key, rest = line:match("^%s*([^:]+)%s*:%s*(.*)$")
    if not key then return nil end

    key = key:match("^%s*(.-)%s*$")

    local path, suffix
    if rest:sub(1, 1) == "'" then
        path, suffix = rest:match("^'([^']+)'%s*(.*)$")
    else
        path, suffix = rest:match("^([^%s]+)%s*(.*)$")
    end

    path = path or rest
    suffix = suffix or ""

    local row_str, col_str = suffix:match("(%d+)%s*[:%s]%s*(%d*)")
    if not row_str then row_str = suffix:match("(%d+)") end

    return {
        key  = key,
        path = path,
        row  = tonumber(row_str) or 1,
        col  = tonumber(col_str) or 0
    }
end

M.edit = function(t)
    local width = 80
    local height = 10
    local ui = vim.api.nvim_list_uis()[1]

    local buf = vim.api.nvim_create_buf(false, true)

    local opts = {
        relative = 'editor',
        width    = width,
        height   = height,
        col      = (ui.width / 2) - (width / 2),
        row      = (ui.height / 2) - (height / 2),
        anchor   = 'NW',
        style    = 'minimal',
    }

    vim.api.nvim_open_win(buf, true, opts)

    vim.keymap.set({ "n" }, "q", "<cmd>q<cr>", { buffer = buf, silent = true })

    local initial_lines = {}
    for key, mark_char in pairs(t) do
        local mark = vim.api.nvim_get_mark(mark_char, {})

        if mark[4] == "" then
            table.insert(initial_lines, key .. ": ")
        else
            table.insert(initial_lines, string.format("%s: '%s' %d:%d", key, mark[4], mark[1], mark[2]))
        end
    end
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, initial_lines)

    vim.api.nvim_create_autocmd('BufHidden', {
        buffer = buf,
        once = true,
        callback = function()
            local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

            for _, line in ipairs(lines) do
                local l = parse_line(line)
                if l then
                    local mark_char = t[l.key]
                    if mark_char then
                        local mark_buf = find_buf(l.path)
                        if mark_buf then
                            local success = vim.api.nvim_buf_set_mark(mark_buf, mark_char, l.row, l.col, {})
                            if not success then
								vim.notify("Failed to set mark " .. mark_char, vim.log.levels.ERROR, {})
                            end
                        end
                    end
                end
            end
        end
    })
end

return M
