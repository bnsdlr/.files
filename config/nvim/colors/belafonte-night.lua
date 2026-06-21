-- A Neovim colorscheme generated from a terminal color palette: https://github.com/mbadolato/iTerm2-Color-Schemes/blob/master/termite/Belafonte%20Night
-- Place at: ~/.config/nvim/colors/belafonte-night.lua.lua
-- Then: :colorscheme belafonte-night

local M = {}

M.colors = {
  bg        = "#20111b",
  fg        = "#968c83",
  cursor    = "#968c83",
  cursor_fg = "#20111b",

  black     = "#20111b",
  red       = "#be100e",
  green     = "#858162",
  yellow    = "#eaa549",
  blue      = "#426a79",
  magenta   = "#97522c",
  cyan      = "#989a9c",
  white     = "#968c83",

  bright_black   = "#5e5252",
  bright_red     = "#be100e",
  bright_green   = "#858162",
  bright_yellow  = "#eaa549",
  bright_blue    = "#426a79",
  bright_magenta = "#97522c",
  bright_cyan    = "#989a9c",
  bright_white   = "#d5ccba",

  bold = "#968c83",

  none = "NONE",
}

function M.setup()
  local c = M.colors

  -- Reset
  vim.cmd("hi clear")
  if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
  end
  vim.o.background = "dark"
  vim.o.termguicolors = true
  vim.g.colors_name = "belafonte-night"

  local function hi(group, opts)
    local fg = opts.fg and ("guifg=" .. opts.fg) or "guifg=NONE"
    local bg = opts.bg and ("guibg=" .. opts.bg) or "guibg=NONE"
    local style = opts.style and ("gui=" .. opts.style) or "gui=NONE"
    local sp = opts.sp and ("guisp=" .. opts.sp) or ""
    vim.cmd(string.format("hi %s %s %s %s %s", group, fg, bg, style, sp))
  end

  -- ============ Editor UI ============
  hi("Normal",       { fg = c.fg, bg = c.bg })
  hi("NormalFloat",  { fg = c.fg, bg = c.bg })
  hi("NormalNC",     { fg = c.fg, bg = c.bg })
  hi("FloatBorder",  { fg = c.bright_black, bg = c.bg })
  hi("Cursor",       { fg = c.cursor_fg, bg = c.cursor })
  hi("CursorLine",   { bg = "#2c1825" })
  hi("CursorLineNr", { fg = c.yellow, style = "bold" })
  hi("LineNr",       { fg = c.bright_black })
  hi("SignColumn",   { fg = c.fg, bg = c.bg })
  hi("ColorColumn",  { bg = "#2c1825" })
  hi("VertSplit",    { fg = c.bright_black, bg = c.bg })
  hi("WinSeparator", { fg = c.bright_black, bg = c.bg })
  hi("Visual",       { bg = "#3a2230" })
  hi("VisualNOS",    { bg = "#3a2230" })
  hi("Search",       { fg = c.bg, bg = c.yellow })
  hi("IncSearch",    { fg = c.bg, bg = c.red })
  hi("CurSearch",    { fg = c.bg, bg = c.red })
  hi("Pmenu",        { fg = c.fg, bg = "#2c1825" })
  hi("PmenuSel",     { fg = c.bg, bg = c.yellow })
  hi("PmenuSbar",    { bg = "#2c1825" })
  hi("PmenuThumb",   { bg = c.bright_black })
  hi("StatusLine",   { fg = c.fg, bg = "#2c1825" })
  hi("StatusLineNC", { fg = c.bright_black, bg = "#2c1825" })
  hi("TabLine",      { fg = c.bright_black, bg = "#2c1825" })
  hi("TabLineFill",  { bg = "#2c1825" })
  hi("TabLineSel",   { fg = c.bg, bg = c.yellow })
  hi("Title",        { fg = c.yellow, style = "bold" })
  hi("Directory",    { fg = c.blue })
  hi("ErrorMsg",     { fg = c.red, style = "bold" })
  hi("WarningMsg",   { fg = c.yellow, style = "bold" })
  hi("MoreMsg",      { fg = c.green })
  hi("Question",     { fg = c.yellow })
  hi("ModeMsg",      { fg = c.fg })
  hi("MsgArea",      { fg = c.fg })
  hi("MatchParen",   { fg = c.bg, bg = c.yellow, style = "bold" })
  hi("NonText",      { fg = c.bright_black })
  hi("Whitespace",   { fg = c.bright_black })
  hi("SpecialKey",   { fg = c.bright_black })
  hi("Folded",       { fg = c.bright_black, bg = "#2c1825" })
  hi("FoldColumn",   { fg = c.bright_black, bg = c.bg })
  hi("WildMenu",     { fg = c.bg, bg = c.yellow })
  hi("EndOfBuffer",  { fg = c.bg })

  -- Diff
  hi("DiffAdd",    { fg = c.green, bg = "#26301f", style = "NONE" })
  hi("DiffChange", { fg = c.yellow, bg = "#332b1a", style = "NONE" })
  hi("DiffDelete", { fg = c.red, bg = "#33181a", style = "NONE" })
  hi("DiffText",   { fg = c.yellow, bg = "#473a1f", style = "bold" })

  -- Spelling
  hi("SpellBad",   { sp = c.red, style = "undercurl" })
  hi("SpellCap",   { sp = c.yellow, style = "undercurl" })
  hi("SpellRare",  { sp = c.cyan, style = "undercurl" })
  hi("SpellLocal", { sp = c.blue, style = "undercurl" })

  -- ============ Syntax ============
  hi("Comment",        { fg = c.bright_black, style = "italic" })
  hi("Constant",        { fg = c.magenta })
  hi("String",          { fg = c.green })
  hi("Character",       { fg = c.green })
  hi("Number",           { fg = c.magenta })
  hi("Boolean",          { fg = c.magenta })
  hi("Float",            { fg = c.magenta })
  hi("Identifier",       { fg = c.fg })
  hi("Function",         { fg = c.yellow, style = "bold" })
  hi("Statement",        { fg = c.red })
  hi("Conditional",      { fg = c.red })
  hi("Repeat",           { fg = c.red })
  hi("Label",            { fg = c.red })
  hi("Operator",         { fg = c.cyan })
  hi("Keyword",          { fg = c.red, style = "bold" })
  hi("Exception",        { fg = c.red })
  hi("PreProc",          { fg = c.cyan })
  hi("Include",          { fg = c.blue })
  hi("Define",           { fg = c.cyan })
  hi("Macro",            { fg = c.cyan })
  hi("PreCondit",        { fg = c.cyan })
  hi("Type",             { fg = c.blue, style = "bold" })
  hi("StorageClass",     { fg = c.blue })
  hi("Structure",        { fg = c.blue })
  hi("Typedef",          { fg = c.blue })
  hi("Special",          { fg = c.yellow })
  hi("SpecialChar",      { fg = c.yellow })
  hi("Tag",              { fg = c.yellow })
  hi("Delimiter",        { fg = c.fg })
  hi("SpecialComment",   { fg = c.bright_black, style = "italic" })
  hi("Debug",            { fg = c.red })
  hi("Underlined",       { style = "underline" })
  hi("Ignore",           { fg = c.bright_black })
  hi("Error",            { fg = c.red, style = "bold" })
  hi("Todo",             { fg = c.bg, bg = c.yellow, style = "bold" })

  -- ============ Treesitter ============
  hi("@variable",          { fg = c.fg })
  hi("@variable.builtin",  { fg = c.magenta })
  hi("@variable.parameter",{ fg = c.fg })
  hi("@constant",          { fg = c.magenta })
  hi("@constant.builtin",  { fg = c.magenta, style = "bold" })
  hi("@string",            { fg = c.green })
  hi("@string.escape",     { fg = c.yellow })
  hi("@number",            { fg = c.magenta })
  hi("@boolean",           { fg = c.magenta })
  hi("@function",          { fg = c.yellow, style = "bold" })
  hi("@function.builtin",  { fg = c.yellow })
  hi("@method",            { fg = c.yellow, style = "bold" })
  hi("@constructor",       { fg = c.blue })
  hi("@keyword",           { fg = c.red, style = "bold" })
  hi("@keyword.function",  { fg = c.red })
  hi("@keyword.return",    { fg = c.red })
  hi("@conditional",       { fg = c.red })
  hi("@repeat",            { fg = c.red })
  hi("@operator",          { fg = c.cyan })
  hi("@punctuation.bracket",   { fg = c.fg })
  hi("@punctuation.delimiter", { fg = c.fg })
  hi("@comment",           { fg = c.bright_black, style = "italic" })
  hi("@type",              { fg = c.blue, style = "bold" })
  hi("@type.builtin",      { fg = c.blue })
  hi("@property",          { fg = c.fg })
  hi("@field",              { fg = c.fg })
  hi("@parameter",         { fg = c.fg, style = "italic" })
  hi("@tag",               { fg = c.red })
  hi("@tag.attribute",     { fg = c.yellow })
  hi("@tag.delimiter",     { fg = c.fg })
  hi("@namespace",         { fg = c.blue })
  hi("@include",           { fg = c.blue })

  -- LSP
  hi("DiagnosticError", { fg = c.red })
  hi("DiagnosticWarn",  { fg = c.yellow })
  hi("DiagnosticInfo",  { fg = c.cyan })
  hi("DiagnosticHint",  { fg = c.blue })
  hi("DiagnosticUnderlineError", { sp = c.red, style = "undercurl" })
  hi("DiagnosticUnderlineWarn",  { sp = c.yellow, style = "undercurl" })
  hi("DiagnosticUnderlineInfo",  { sp = c.cyan, style = "undercurl" })
  hi("DiagnosticUnderlineHint",  { sp = c.blue, style = "undercurl" })
  hi("LspReferenceText",  { bg = "#2c1825" })
  hi("LspReferenceRead",  { bg = "#2c1825" })
  hi("LspReferenceWrite", { bg = "#3a2230" })

  -- Git
  hi("GitSignsAdd",    { fg = c.green })
  hi("GitSignsChange", { fg = c.yellow })
  hi("GitSignsDelete", { fg = c.red })
  hi("DiffAdded",   { fg = c.green })
  hi("DiffRemoved", { fg = c.red })

  -- Telescope
  hi("TelescopeBorder",        { fg = c.bright_black, bg = c.bg })
  hi("TelescopeNormal",        { fg = c.fg, bg = c.bg })
  hi("TelescopeSelection",     { fg = c.bg, bg = c.yellow, style = "bold" })
  hi("TelescopeMatching",      { fg = c.red, style = "bold" })
  hi("TelescopePromptBorder",  { fg = c.bright_black, bg = c.bg })

  -- NvimTree / Neo-tree
  hi("NvimTreeFolderIcon",  { fg = c.blue })
  hi("NvimTreeFolderName",  { fg = c.blue })
  hi("NvimTreeOpenedFolderName", { fg = c.blue, style = "bold" })
  hi("NvimTreeRootFolder",  { fg = c.yellow, style = "bold" })
  hi("NvimTreeIndentMarker",{ fg = c.bright_black })
  hi("NvimTreeNormal",      { fg = c.fg, bg = c.bg })
  hi("NeoTreeNormal",       { fg = c.fg, bg = c.bg })
  hi("NeoTreeDirectoryIcon",{ fg = c.blue })
  hi("NeoTreeDirectoryName",{ fg = c.blue })

  -- Terminal colors
  vim.g.terminal_color_0  = c.black
  vim.g.terminal_color_1  = c.red
  vim.g.terminal_color_2  = c.green
  vim.g.terminal_color_3  = c.yellow
  vim.g.terminal_color_4  = c.blue
  vim.g.terminal_color_5  = c.magenta
  vim.g.terminal_color_6  = c.cyan
  vim.g.terminal_color_7  = c.white
  vim.g.terminal_color_8  = c.bright_black
  vim.g.terminal_color_9  = c.bright_red
  vim.g.terminal_color_10 = c.bright_green
  vim.g.terminal_color_11 = c.bright_yellow
  vim.g.terminal_color_12 = c.bright_blue
  vim.g.terminal_color_13 = c.bright_magenta
  vim.g.terminal_color_14 = c.bright_cyan
  vim.g.terminal_color_15 = c.bright_white
  vim.g.terminal_color_background = c.bg
  vim.g.terminal_color_foreground = c.fg
end

M.setup()
return M
