local border = "single"

-- bind :w to :up
vim.cmd('ca w up')

-- plugins
vim.pack.add({
	"https://github.com/vague2k/vague.nvim",
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

-- colorscheme
vim.cmd('colorscheme vague')
vim.cmd('hi statusline guibg=NONE')

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
map({ "n" }, "<C-t><C-c>", "<cmd>tabnew<CR>") -- not working
map({ "n" }, "<C-t>x", "<cmd>tabclose<CR>")
map({ "n" }, "<C-t><C-x>", "<cmd>tabclose<CR>")

map({ "n" }, "<leader>tn", "<cmd>tabnext<CR>")
map({ "n" }, "<leader>tp", "<cmd>tabprevious<CR>")
map({ "n" }, "<leader>tc", "<cmd>tabnew<CR>")
map({ "n" }, "<leader>tx", "<cmd>tabclose<CR>")
map({ "n" }, "<leader>tm", ":tabmove ")

map({ "n" }, "<leader>m", ":make<CR>")

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
	"lua_ls",
	"jsonls",
	"svelte",
	"pyright",
	"html",
	"tsgo",
	"cssls",
	"zls",
})

vim.g.zig_fmt_autosave = 0

vim.lsp.config['zls'] = {
  cmd = { 'zls' },
  filetypes = { 'zig' },
  root_markers = { 'build.zig' },
}

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
map({ "n" }, "<leader>lr", builtin.lsp_references)

require"vim._core.ui2".enable{}
