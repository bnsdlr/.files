vim.cmd([[set mouse=]])

vim.opt.winborder = "single"
vim.opt.pumborder = "single"

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.winborder = "single"
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.wrap = false
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.ignorecase = true
vim.opt.signcolumn = "yes"

-- plugins
vim.pack.add({
	{ src = "https://github.com/vague2k/vague.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/aznhe21/actions-preview.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim",          version = "0.1.8" },
	{ src = "https://github.com/nvim-telescope/telescope-ui-select.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter",        version = "main" },
	{ src = "https://github.com/mbbill/undotree" },
	-- lsp
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/Saghen/blink.cmp" },
	-- language plugins
	{ src = "https://github.com/mrcjkb/rustaceanvim" },
})

-- require("nvim-treesitter.config").setup({ highlight = { enable = true } })

local telescope = require "telescope"
telescope.setup({
	defaults = {
		preview = { treesitter = false },
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

require("actions-preview").setup {
	backend = { "telescope" },
	telescope = vim.tbl_extend(
		"force",
		require("telescope.themes").get_dropdown(), {}
	)
}

require("oil").setup({
	lsp_file_methods = {
		enabled = true,
		timeout_ms = 1000,
		autosave_changes = true,
	},
	columns = {
		"permissions",
		"icon",
	},
	float = {
		max_width = 0.7,
		max_height = 0.6,
		border = "single",
	},
})

local function get_plugins()
	local active_plugins = {}
	local unused_plugins = {}

	for _, plugin in ipairs(vim.pack.get()) do
		if plugin.active then
			table.insert(active_plugins, plugin.spec.name)
		else
			table.insert(unused_plugins, plugin.spec.src)
		end
	end

	-- vim.print(active_plugins)
	-- vim.print(unused_plugins)

	return active_plugins, unused_plugins
end

local function pack_update()
	local active_plugins, _ = get_plugins()

	if #active_plugins == 0 then
		print("No active plugins.")
		return
	end

	local choice = vim.fn.confirm("Update active plugins?", "&Yes\n&No", 2)
	if choice == 1 then
		vim.pack.update(active_plugins)
	end
end

local function pack_clean()
	local _, unused_plugins = get_plugins()

	if #unused_plugins == 0 then
		print("No unused plugins.")
		return
	end

	local choice = vim.fn.confirm("Remove unused plugins?", "&Yes\n&No", 2)
	if choice == 1 then
		vim.pack.del(unused_plugins)
	end
end

vim.api.nvim_create_user_command("PackClean", pack_clean, {})
vim.api.nvim_create_user_command("PackUpdate", pack_update, {})

local builtin = require("telescope.builtin")
local map = vim.keymap.set
vim.g.mapleader = " "

map({ "n" }, "<leader>f", builtin.find_files, { desc = "Telescope live grep" })
map({ "n" }, "<leader>g", builtin.live_grep, { desc = "Telescope live grep" })
map({ "n" }, "<leader>b", builtin.buffers, { desc = "Telescope buffers" })
map({ "n" }, "<leader>si", builtin.grep_string, { desc = "Telescope live string" })
map({ "n" }, "<leader>so", builtin.oldfiles, { desc = "Telescope buffers" })
map({ "n" }, "<leader>sh", builtin.help_tags, { desc = "Telescope help tags" })
map({ "n" }, "<leader>sm", builtin.man_pages, { desc = "Telescope man pages" })
map({ "n" }, "<leader>sr", builtin.lsp_references, { desc = "Telescope tags" })
map({ "n" }, "<leader>sb", builtin.builtin, { desc = "Telescope tags" })
map({ "n" }, "<leader>sd", builtin.registers, { desc = "Telescope tags" })
map({ "n" }, "<leader>sc", builtin.colorscheme, { desc = "Telescope tags" })
map({ "n" }, "<leader>sj", builtin.jumplist, { desc = "Telescope tags" })
map({ "n" }, "<leader>sa", require("actions-preview").code_actions)

map({ "n" }, "<C-j>", "<cmd>resize +2<CR>")
map({ "n" }, "<C-k>", "<cmd>resize -2<CR>")
map({ "n" }, "<C-e>", "<cmd>vertical resize +5<CR>")
map({ "n" }, "<C-m>", "<cmd>vertical resize -5<CR>")

map({ "n" }, "<leader>v", "<cmd>e $MYVIMRC<CR>'\"")

map({ "n" }, "<leader>u", vim.cmd.UndotreeToggle)

map({ "n" }, "<C-d>", "<C-d>zz")
map({ "n" }, "<C-u>", "<C-u>zz")
map({ "n" }, "n", "nzz")
map({ "n" }, "N", "Nzz")

map({ "n", "v", "x" }, "<leader>y", "\"+y")
map({ "n", "v", "x" }, "<leader>d", "\"_d")
map({ "n", "v", "x" }, "<leader>c", "\"_c")

map({ "n" }, "<leader>e", "<cmd>Oil<CR>")

map({ "n" }, "<leader>cn", "<cmd>cnext<CR>")
map({ "n" }, "<leader>cp", "<cmd>cprev<CR>")
map({ "n" }, "<leader>cc", "<cmd>cclose<CR>")
map({ "n" }, "<leader>co", "<cmd>copen<CR>")

map({ "n" }, "<C-n>", "<cmd>next<CR>")
map({ "n" }, "<C-p>", "<cmd>prev<CR>")

map({ "v" }, "<leader>n", ":norm ")

-- lsp
require "mason".setup()

vim.lsp.enable({
	"lua_ls",
	"jsonls",
	"pyright",
})

-- vim.api.nvim_create_autocmd('LspAttach', {
-- 	group = vim.api.nvim_create_augroup('my.lsp', {}),
-- 	callback = function(args)
-- 		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
-- 		if client:supports_method('textDocument/completion') then
-- 			-- Optional: trigger autocompletion on EVERY keypress. May be slow!
-- 			local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
-- 			client.server_capabilities.completionProvider.triggerCharacters = chars
-- 			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
-- 		end
-- 	end,
-- })
-- vim.cmd [[set completeopt+=menuone,noselect,popup]]

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

-- colorscheme
vim.cmd('colorscheme vague')
vim.cmd('hi statusline guibg=NONE')
