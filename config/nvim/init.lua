local border = "single"
local default_theme = "vague"

-- plugins
vim.pack.add({
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-telescope/telescope.nvim",
	"https://github.com/nvim-telescope/telescope-ui-select.nvim",
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", branch = "main" },
	-- image
	"https://github.com/3rd/image.nvim",
	-- lsp
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	{ src = "https://github.com/Saghen/blink.cmp", branch = "v1" },
	-- language plugins
	"https://github.com/mrcjkb/rustaceanvim",
	"https://codeberg.org/ziglang/zig.vim",
	-- themes
	"https://github.com/vague2k/vague.nvim",
	"https://github.com/metalelf0/black-metal-theme-neovim",
	"https://github.com/webhooked/kanso.nvim",
	{ src = "https://github.com/rose-pine/neovim", name = "rose-pine" },
	"https://github.com/savq/melange-nvim",
})

vim.cmd.packadd('nvim.undotree')

-- oil
require("oil").setup({
	lsp_file_methods = {
		enabled = true,
		timeout_ms = 1000,
		autosave_changes = true,
	},
	columns = {
		-- "permissions",
		"icon",
	},
	float = {
		max_width = 0.7,
		max_height = 0.6,
		border = border,
	},
	view_options = {
		show_hidden = true,
		is_always_hidden = function(name, _)
			return name:match("%.%.") ~= nil
		end,
	},
	delete_to_trash = true,
	skip_confirm_for_simple_edits = true,
})

-- options
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:block,r-cr-o:block"

vim.opt.colorcolumn = "100"
vim.opt.foldmethod = "marker"
vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.number = true
vim.opt.pumborder = border
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.shiftwidth = 4
vim.opt.signcolumn = "yes"
vim.opt.smartindent = true
vim.opt.swapfile = false
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.winborder = border
vim.opt.wrap = false
vim.opt.termguicolors = false

-- only highlight with treesitter
vim.cmd('syntax off')

vim.api.nvim_create_autocmd('FileType', {
    callback = function() pcall(vim.treesitter.start) end,
})

require('nvim-treesitter').install {
	"bash",
	"elixir",
	"git_config",
	"git_rebase",
	"gitcommit",
	"gitignore",
	"c",
	"cpp",
	"html",
	"javascript",
	"lua",
	"markdown",
	"rust",
	"zig",
	"zsh",
}

local telescope = require "telescope"
telescope.setup({
	defaults = {
		preview = { treesitter = true },
		color_devicons = true,
		sorting_strategy = "ascending",
		borderchars = { "", "", "", "", "", "", "", "" },
		path_displays = "smart",
		layout_strategy = "horizontal",
		layout_config = {
			height = 100,
			width = 400,
			prompt_position = "top",
			preview_cutoff = 40,
		}
	}
})
telescope.load_extension("ui-select")

-- maps{{{
local builtin = require("telescope.builtin")
local map = vim.keymap.set
vim.g.mapleader = " "

map({ "n" }, "<leader>bs", "<cmd>update<CR>", { desc = "update current buffer (write if changed)" })
map({ "n" }, "<leader>x", "<cmd>xit<CR>", { desc = "like: :update|quit" })

map({ "n" }, "<leader>w", "<C-w>")

map({ "n" }, "<", "<<");
map({ "n" }, ">", ">>");

map({ "n" }, "<leader>f", builtin.find_files, { desc = "Telescope live grep" })
map({ "n" }, "<leader>g", builtin.live_grep, { desc = "Telescope live grep" })
map({ "n" }, "<leader>sm", builtin.man_pages, { desc = "Telescope man pages" })
map({ "n" }, "<leader>sh", builtin.help_tags, { desc = "Telescope help tags" })

map({ "n" }, "<leader>G", builtin.git_commits, { desc = "Telescope git_commit" })

map({ "n" }, "<leader>sb", builtin.buffers, { desc = "Telescope buffers" })
map({ "n" }, "<leader>so", builtin.oldfiles, { desc = "Telescope oldfiles" })
map({ "n" }, "<leader>st", builtin.builtin, { desc = "Telescope builtins" })
map({ "n" }, "<leader>sr", builtin.registers, { desc = "Telescope registers" })
map({ "n" }, "<leader>sc", builtin.colorscheme, { desc = "Telescope colorschemes" })
map({ "n" }, "<leader>sa", builtin.marks, { desc = "Telescope marks" })

map({ "n" }, "<leader>v", "<cmd>e $MYVIMRC<CR>'\"")

map({ "n" }, "<leader>u", vim.cmd.Undotree)

map({ "n" }, "<C-d>", "<C-d>zz")
map({ "n" }, "<C-u>", "<C-u>zz")
map({ "n" }, "n", "nzz")
map({ "n" }, "N", "Nzz")

map({ "n", "v", "x" }, "<leader>y", "\"+y")
map({ "n", "v", "x" }, "<leader>d", "\"_d")
map({ "n", "v", "x" }, "<leader>c", "\"_c")

map({ "n" }, "<leader>e", "<cmd>Oil<CR>")

map({ "n" }, "<C-c>", "")
map({ "n" }, "<C-c><C-n>", "<cmd>cnext<CR>")
map({ "n" }, "<C-c><C-p>", "<cmd>cprev<CR>")
map({ "n" }, "<C-c><C-c>", "<cmd>cclose<CR>")
map({ "n" }, "<C-c><C-o>", "<cmd>copen<CR>")

map({ "n" }, "<C-t>n", "<cmd>tabnext<CR>")
map({ "n" }, "<C-t><C-n>", "<cmd>tabnext<CR>")
map({ "n" }, "<C-t>p", "<cmd>tabprevious<CR>")
map({ "n" }, "<C-t><C-p>", "<cmd>tabprevious<CR>")
map({ "n" }, "<C-t>c", "<cmd>tabnew<CR>")
map({ "n" }, "<C-t><C-c>", "<cmd>tabnew<CR>")
map({ "n" }, "<C-t>x", "<cmd>tabclose<CR>")
map({ "n" }, "<C-t><C-x>", "<cmd>tabclose<CR>")

map({ "c" }, "<C-b>", "<Left>");
map({ "c" }, "<C-f>", "<Right>");

map({ "i" }, "<C-a>", "<Home>")
map({ "i" }, "<C-e>", "<End>")
map({ "i" }, "<C-b>", "<Left>")
map({ "i" }, "<C-f>", "<Right>")
map({ "i" }, "<C-p>", "<Up>")
map({ "i" }, "<C-n>", "<Down>")
map({ "i" }, "<C-k>", "<C-o><C-r>")
map({ "i" }, "<C-u>", "<C-o>u")
-- }}}

-- image
require("image").setup({
  max_width_window_percentage = 100,
  max_height_window_percentage = 80,
  scale_factor = 1.0,
})

-- lsp{{{
require "mason".setup()

vim.lsp.enable({
	"clangd",
	"cssls",
	"html",
	"jsonls",
	"lua_ls",
	"pyright",
	"svelte",
	"tsgo",
	"zls",
})

vim.g.zig_fmt_autosave = 0

vim.lsp.config['zls'] = {
  cmd = { 'zls' },
  filetypes = { 'zig' },
  root_markers = { 'build.zig' },
  settings = {
	  zls = {
		  enable_build_on_save = true,
	  }
  }
}

require('blink.cmp').setup({
	fuzzy = { implementation = "lua" },
	sources = { default = { 'lsp', 'path', 'buffer' } },
	completion = {
		documentation = { auto_show = true, auto_show_delay_ms = 0 },
		menu = { max_height = 10 }
	},
	keymap = {
		preset = 'default',
		['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
		['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
	}
})

map({ "n" }, "K", function() vim.lsp.buf.hover { max_height = 25, max_width = 120 } end)
map({ "n" }, "gd", vim.lsp.buf.definition)
map({ "n" }, "gt", vim.lsp.buf.type_definition)
map({ "n" }, "<leader>ld", vim.diagnostic.open_float)
map({ "n" }, "<leader>lf", vim.lsp.buf.format)
map({ "n" }, "<leader>lr", builtin.lsp_references)
-- }}}

require"vim._core.ui2".enable{}

-- colorscheme{{{
-- vim.cmd('colorscheme vague')
vim.cmd('hi statusline guibg=NONE')

require("black-metal").setup({
  -- theme = "bathory",
  favor_treesitter_hl = true,
})
require('kanso').setup({ minimal = false })

local function update_ghostty_theme(name)
	os.execute("$HOME/.config/scripts/switch-theme.sh \"" .. name .. "\" >/dev/null 2>&1")
end

local THEMES = {
	["belafonte"] = { callback = function()
		vim.opt.termguicolors = false
		update_ghostty_theme("Belafonte Night")
	end },
	["rose-pine"] = { nvim = true, callback = function() update_ghostty_theme("Rose Pine") end },
	["melange"] = { nvim = true, callback = function() update_ghostty_theme("Melange Dark") end },
	["vague"] = { nvim = true, callback = function() update_ghostty_theme("vague") end },
	["kanso"] = { nvim = true, callback = function() update_ghostty_theme("Kanso Ink") end },
	["black-metal"] = {
		["impaled-nazarene"] = { nvim = true, callback = function() update_ghostty_theme("Black Metal") end },
		["bathory"] = { nvim = true, callback = function() update_ghostty_theme("Black Metal (Bathory)") end },
		["burzum"] = { nvim = true, callback = function() update_ghostty_theme("Black Metal (Burzum)") end },
		["dark-funeral"] = { nvim = true, callback = function() update_ghostty_theme("Black Metal (Dark Funeral)") end },
		["gorgoroth"] = { nvim = true, callback = function() update_ghostty_theme("Black Metal (Gorgoroth)") end },
		["immortal"] = { nvim = true, callback = function() update_ghostty_theme("Black Metal (Immortal)") end },
		["khold"] = { nvim = true, callback = function() update_ghostty_theme("Black Metal (Khold)") end },
		["marduk"] = { nvim = true, callback = function() update_ghostty_theme("Black Metal (Marduk)") end },
		["mayhem"] = { nvim = true, callback = function() update_ghostty_theme("Black Metal (Mayhem)") end },
		["nile"] = { nvim = true, callback = function() update_ghostty_theme("Black Metal (Nile)") end },
		["venom"] = { nvim = true, callback = function() update_ghostty_theme("Black Metal (Venom)") end },
	},
-- Arthur
-- Belafonte Night
-- Flexoki Dark
-- Red Planet
}

local function theme_opts(t, key)
	for k, v in pairs(t) do
		if type(v) == "table" and v.callback == nil then
			local opts = theme_opts(v, key)
			if opts ~= nil then return opts end
		else
			if k == key then return v end
		end
	end
	return nil
end

local function get_cur_theme_file_path()
	local nvim_config_dir = vim.call("stdpath", "data")
	return nvim_config_dir .. "/current_theme"
end

local function retry_open_cur_theme_file(mode)
	local current_theme_file = get_cur_theme_file_path()
	local fd, err, _ = vim.uv.fs_open(current_theme_file, mode, tonumber("644", 8))
	if fd == nil then
		vim.notify("" .. err, vim.log.levels.ERROR)
		return
	end
	return fd
end

local function open_cur_theme_file(mode)
	local current_theme_file = get_cur_theme_file_path()
	local fd, err, _ = vim.uv.fs_open(current_theme_file, mode, tonumber("644", 8))
	if fd == nil then
		fd, err = vim.uv.fs_open(current_theme_file, "w", tonumber("664", 8))
		if fd == nil then
			vim.notify("" .. err, vim.log.levels.ERROR)
		else
			vim.uv.fs_write(fd, default_theme)
			return retry_open_cur_theme_file(mode)
		end
		return
	end
	return fd
end

local function swap_theme(name, verbose, update_cur_theme_file, run_callback)
	if update_cur_theme_file then
		local fd = open_cur_theme_file("w")
		if fd == nil then return end
		local _, err = vim.uv.fs_write(fd, name, nil)
		vim.uv.fs_close(fd)
		if err ~= nil then
			vim.notify(err, vim.log.levels.ERROR)
			return
		end
	end

	vim.notify("New theme: " .. name, vim.log.levels.INFO)

	local opts = theme_opts(THEMES, name)
	vim.inspect(opts)

	if opts == nil then
		if verbose then vim.notify(name .. " has no equvivalent ghostty theme.", vim.log.levels.INFO) end
	else
		if type(opts.nvim) == "boolean" then
			vim.cmd("colorscheme " .. name)
		elseif type(opts.nvim) == "string" then
			vim.cmd("colorscheme " .. opts.nvim)
		end

		if run_callback and opts.callback ~= nil then
			opts.callback()
		end
	end
end

local function get_cur_theme()
	local fd = open_cur_theme_file("r")
	if fd == nil then return default_theme end
	local cur = vim.uv.fs_read(fd, 1000, nil)
	vim.uv.fs_close(fd)
	if cur == "" then return default_theme else return cur end
end

local function SwapTheme(opts)
	swap_theme(opts.fargs[1], true, true, true)
end

local function random_key(t)
	local keyset = {}
	for key, _ in pairs(t) do
		table.insert(keyset, key)
	end
	local key = keyset[math.random(#keyset)]
	if type(THEMES[key]) == "table" and THEMES[key].callback == nil then
		return random_key(THEMES[key])
	else
		return key
	end
end

local function RandomTheme()
	local current_theme = get_cur_theme()
	local rand = random_key(THEMES)
	local count = 0
	while current_theme == rand and count < 3 do
		count = count + 1
		rand = random_key(THEMES)
	end
	current_theme = rand
	swap_theme(rand, false, true, true)
end

local function CurTheme()
	vim.notify("Current theme: " .. get_cur_theme(), vim.log.levels.INFO)
end

swap_theme(get_cur_theme(), false, false, false)

vim.api.nvim_create_user_command("SwapTheme", SwapTheme, { nargs = 1 })
vim.api.nvim_create_user_command("RandomTheme", RandomTheme, {})
vim.api.nvim_create_user_command("CurTheme", CurTheme, {})

map({ "n" }, "<leader>t", function()
	RandomTheme()
	os.execute("pkill -USR1 nvim")
end)

vim.api.nvim_create_autocmd("Signal", {
	pattern = "SIGUSR1",
	group = vim.api.nvim_create_augroup("switch_theme_on_SIGUSR1", {}),
	callback = function()
		swap_theme(get_cur_theme(), false, false, false)
		vim.schedule(function()
		  vim.cmd("redraw!")
		end)
	end,
	nested = true,
})

-- }}}
