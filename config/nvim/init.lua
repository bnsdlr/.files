local border = "single"

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
	"https://github.com/rebelot/kanagawa.nvim",
	"https://github.com/webhooked/kanso.nvim",
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

-- image

require("image").setup({
  max_width_window_percentage = 100,
  max_height_window_percentage = 80,
  scale_factor = 1.0,
})

-- lsp
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

require"vim._core.ui2".enable{}

map({ "i" }, "<C-a>", "<Home>")
map({ "i" }, "<C-e>", "<End>")
map({ "i" }, "<C-b>", "<Left>")
map({ "i" }, "<C-f>", "<Right>")
map({ "i" }, "<C-p>", "<Up>")
map({ "i" }, "<C-n>", "<Down>")
map({ "i" }, "<C-k>", "<C-o><C-r>")
map({ "i" }, "<C-u>", "<C-o>u")

-- colorscheme{{{
-- vim.cmd('colorscheme vague')
vim.cmd('hi statusline guibg=NONE')

require("black-metal").setup({-- {{{
  theme = "bathory",
  -- Can be one of: 'light' | 'dark', or set via vim.o.background
  variant = "dark",
  -- Use an alternate, lighter bg
  alt_bg = false,
  -- If true, docstrings will be highlighted like strings, otherwise they will be
  -- highlighted like comments. Note, behavior is dependent on the language server.
  colored_docstrings = true,
  -- If true, highlights the {sign,fold} column the same as cursorline
  cursorline_gutter = true,
  -- If true, highlights the gutter darker than the bg
  dark_gutter = false,
  -- if true favor treesitter highlights over semantic highlights
  favor_treesitter_hl = false,
  -- Don't set background of floating windows. Recommended for when using floating
  -- windows with borders.
  plain_float = false,
  -- Show the end-of-buffer character
  show_eob = true,
  -- If true, enable the vim terminal colors
  term_colors = true,
  -- Keymap (in normal mode) to toggle between light and dark variants.
  toggle_variant_key = nil,
  -- Don't set background
  transparent = false,

  -----DIAGNOSTICS and CODE STYLE-----
  --
  diagnostics = {
    darker = true, -- Darker colors for diagnostic
    undercurl = true, -- Use undercurl for diagnostics
    background = true, -- Use background color for virtual text
  },
  -- The following table accepts values the same as the `gui` option for normal
  -- highlights. For example, `bold`, `italic`, `underline`, `none`.
  code_style = {
    comments = "italic",
    conditionals = "none",
    functions = "none",
    keywords = "none",
    headings = "bold", -- Markdown headings
    operators = "none",
    keyword_return = "none",
    strings = "none",
    variables = "none",
  },

  plugin = {
    cmp = { -- works for nvim.cmp and blink.nvim
      -- Don't highlight lsp-kind items. Only the current selection will be highlighted.
      plain = false,
      -- Reverse lsp-kind items' highlights in blink/cmp menu.
      reverse = false,
    },
  },
  colors = {},
  highlights = {},
})-- }}}
require('kanagawa').setup({-- {{{
    compile = false,             -- enable compiling the colorscheme
    undercurl = true,            -- enable undercurls
    commentStyle = { italic = true },
    functionStyle = {},
    keywordStyle = { italic = true},
    statementStyle = { bold = true },
    typeStyle = {},
    transparent = false,         -- do not set background color
    dimInactive = false,         -- dim inactive window `:h hl-NormalNC`
    terminalColors = true,       -- define vim.g.terminal_color_{0,17}
    colors = {                   -- add/modify theme and palette colors
        palette = {},
        theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
    },
    overrides = function(colors) -- add/modify highlights
        return {}
    end,
    theme = "dragon",              -- Load "wave" theme
    background = {               -- map the value of 'background' option to a theme
        dark = "dragon",           -- try "dragon" !
        light = "lotus"
    },
})-- }}}
require('kanso').setup({-- {{{
    bold = true,                 -- enable bold fonts
    italics = true,             -- enable italics
    compile = false,             -- enable compiling the colorscheme
    undercurl = true,            -- enable undercurls
    commentStyle = { italic = true },
    functionStyle = {},
    keywordStyle = { italic = true},
    statementStyle = {},
    typeStyle = {},
    transparent = false,         -- do not set background color
    dimInactive = false,         -- dim inactive window `:h hl-NormalNC`
    terminalColors = true,       -- define vim.g.terminal_color_{0,17}
    colors = {                   -- add/modify theme and palette colors
        palette = {},
        theme = { zen = {}, pearl = {}, ink = {}, all = {} },
    },
    overrides = function(colors) -- add/modify highlights
        return {}
    end,
    background = {               -- map the value of 'background' option to a theme
        dark = "ink",           -- try "zen", "mist" or "pearl" !
        light = "pearl"         -- try "zen", "mist" or "ink" !
    },
    foreground = "default",      -- "default" or "saturated" (can also be a table like background)
    minimal = false,             -- reduced color palette for a more minimal look
})-- }}}

local current_theme = nil
local THEMES = {
	["vague"] = "vague",
	["kanagawa"] = "Kanagawa Dragon",
	["kanso"] = "Kanso Ink",
	["black-metal"] = {
		["darkthrone"] = "Black Metal",
		["emperor"] = "Black Metal",
		["taake"] = "Black Metal",
		["thyrfing"] = "Black Metal",
		["windir"] = "Black Metal",
		["impaled-nazarene"] = "Black Metal",
		["bathory"] = "Black Metal (Bathory)",
		["burzum"] = "Black Metal (Burzum)",
		["dark-funeral"] = "Black Metal (Dark Funeral)",
		["gorgoroth"] = "Black Metal (Gorgoroth)",
		["immortal"] = "Black Metal (Immortal)",
		["khold"] = "Black Metal (Khold)",
		["marduk"] = "Black Metal (Marduk)",
		["mayhem"] = "Black Metal (Mayhem)",
		["nile"] = "Black Metal (Nile)",
		["venom"] = "Black Metal (Venom)",
	},
-- Arthur
-- Belafonte Night
-- Flexoki Dark
-- Red Planet
}

local function ghostty_theme_name(t, key)
	for k, v in pairs(t) do
		if type(v) == "table" then
			local name = ghostty_theme_name(t[k], key)
			if name ~= nil then return name end
		else
			if k == key then return v end
		end
	end
	return nil
end

local function open_cur_theme_file(mode)
	local nvim_config_dir = vim.call("stdpath", "data")
	local current_theme_file = nvim_config_dir .. "/current_theme"
	local fd = vim.uv.fs_open(current_theme_file, mode, tonumber("644", 8))
	if fd == nil then
		vim.notify("Could not open " .. current_theme_file, vim.log.levels.ERROR)
		return
	end
	return fd
end

local function swap_theme(name, verbose)
	local fd = open_cur_theme_file("w")
	if fd == nil then return end
	vim.uv.fs_write(fd, name, nil)

	if verbose then vim.notify("New theme: " .. name, vim.log.levels.INFO) end
	vim.cmd("colorscheme " .. name)

	local ghostty_name = ghostty_theme_name(THEMES, name)

	if ghostty_name == nil then
		if verbose then vim.notify(name .. " has no equvivalent ghostty theme.", vim.log.levels.INFO) end
	else
		if verbose then vim.notify("Setting gostty theme to " .. ghostty_name, vim.log.levels.INFO) end
		os.execute("$HOME/.config/scripts/switch-theme.sh \"" .. ghostty_name .. "\" >/dev/null 2>&1")
	end
end

local function get_cur_theme()
	local fd = open_cur_theme_file("r")
	if fd == nil then return end
	local cur = vim.uv.fs_read(fd, 1000, nil)
	if cur == "" then return "vague" else return cur end
end

local function SwapTheme(opts)
	swap_theme(opts.fargs[1], true)
end

local function random_key(t)
	local keyset = {}
	for key, _ in pairs(t) do
		table.insert(keyset, key)
	end
	local key = keyset[math.random(#keyset)]
	if type(THEMES[key]) == "table" then
		return random_key(THEMES[key])
	else
		return key
	end
end

local function RandomTheme()
	local rand = random_key(THEMES)
	while current_theme == rand and #THEMES > 1 do
		rand = random_key(THEMES)
	end
	current_theme = rand
	swap_theme(rand, false)
end

swap_theme(get_cur_theme(), false)
-- RandomTheme()

vim.api.nvim_create_user_command("SwapTheme", SwapTheme, { nargs = 1 })
vim.api.nvim_create_user_command("RandomTheme", RandomTheme, {})

map({ "n" }, "<leader>t", RandomTheme)

vim.api.nvim_create_autocmd("Signal", {
	pattern = "SIGUSR1",
	group = vim.api.nvim_create_augroup("switch_theme_on_SIGUSR1", {}),
	callback = function()
		RandomTheme()
		vim.schedule(function()
		  vim.cmd("redraw!")
		end)
	end,
	nested = true,
})
-- }}}
