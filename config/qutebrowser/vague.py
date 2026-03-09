# Vague theme for qutebrowser

c.fonts.default_size = "18px"

# --- Base backgrounds ---

bg0_hard = "#141415"
bg0_soft = "#1c1c1f"
bg0_normal = "#141415"

bg0 = bg0_normal
bg1 = "#1f2023"
bg2 = "#2a2c2f"
bg3 = "#333738"
bg4 = "#606079"

# --- Foregrounds ---

fg0 = "#c3c3d5"
fg1 = "#cdcdcd"
fg2 = "#bdbdc6"
fg3 = "#a5a5b3"
fg4 = "#8f8fa3"

# --- Bright palette (from vague bright) ---

bright_red = "#d8647e"
bright_green = "#7fa563"
bright_yellow = "#f3be7c"
bright_blue = "#7e98e8"
bright_purple = "#bb9dbd"
bright_aqua = "#b4d4cf"
bright_gray = "#c3c3d5"
bright_orange = "#f3be7c"

# --- Normal palette (mapped as dark variants) ---

dark_red = "#d8647e"
dark_green = "#7fa563"
dark_yellow = "#e0a363"
dark_blue = "#6e94b2"
dark_purple = "#bb9dbd"
dark_aqua = "#9bb4bc"
dark_gray = "#606079"
dark_orange = "#e0a363"


### Completion

c.colors.completion.fg = [fg1, bright_aqua, bright_yellow]

c.colors.completion.odd.bg = bg0
c.colors.completion.even.bg = bg0

c.colors.completion.category.fg = bright_blue
c.colors.completion.category.bg = bg1
c.colors.completion.category.border.top = bg1
c.colors.completion.category.border.bottom = bg1

c.colors.completion.item.selected.fg = fg0
c.colors.completion.item.selected.bg = bg4
c.colors.completion.item.selected.border.top = bg2
c.colors.completion.item.selected.border.bottom = bg2

c.colors.completion.item.selected.match.fg = bright_orange
c.colors.completion.match.fg = bright_orange

c.colors.completion.scrollbar.fg = fg0
c.colors.completion.scrollbar.bg = bg1


### Context menu

c.colors.contextmenu.disabled.bg = bg3
c.colors.contextmenu.disabled.fg = fg3

c.colors.contextmenu.menu.bg = bg0
c.colors.contextmenu.menu.fg = fg2

c.colors.contextmenu.selected.bg = bg2
c.colors.contextmenu.selected.fg = fg2


### Downloads

c.colors.downloads.bar.bg = bg0

c.colors.downloads.start.fg = bg0
c.colors.downloads.start.bg = bright_blue

c.colors.downloads.stop.fg = bg0
c.colors.downloads.stop.bg = bright_aqua

c.colors.downloads.error.fg = bright_red


### Hints

c.colors.hints.fg = bg0
c.colors.hints.bg = "rgba(243, 190, 124, 200)"  # bright_yellow
c.colors.hints.match.fg = bg4


### Keyhint widget

c.colors.keyhint.fg = fg4
c.colors.keyhint.suffix.fg = fg0
c.colors.keyhint.bg = bg0


### Messages

c.colors.messages.error.fg = bg0
c.colors.messages.error.bg = bright_red
c.colors.messages.error.border = bright_red

c.colors.messages.warning.fg = bg0
c.colors.messages.warning.bg = bright_purple
c.colors.messages.warning.border = bright_purple

c.colors.messages.info.fg = fg2
c.colors.messages.info.bg = bg0
c.colors.messages.info.border = bg0


### Prompts

c.colors.prompts.fg = fg2
c.colors.prompts.border = f"1px solid {bg1}"
c.colors.prompts.bg = bg3
c.colors.prompts.selected.bg = bg2


### Statusbar

c.colors.statusbar.normal.fg = fg2
c.colors.statusbar.normal.bg = bg0

c.colors.statusbar.insert.fg = bg0
c.colors.statusbar.insert.bg = dark_aqua

c.colors.statusbar.passthrough.fg = bg0
c.colors.statusbar.passthrough.bg = dark_blue

c.colors.statusbar.private.fg = bright_purple
c.colors.statusbar.private.bg = bg0

c.colors.statusbar.command.fg = fg3
c.colors.statusbar.command.bg = bg1

c.colors.statusbar.command.private.fg = bright_purple
c.colors.statusbar.command.private.bg = bg1

c.colors.statusbar.caret.fg = bg0
c.colors.statusbar.caret.bg = dark_purple

c.colors.statusbar.caret.selection.fg = bg0
c.colors.statusbar.caret.selection.bg = bright_purple

c.colors.statusbar.progress.bg = bright_blue

c.colors.statusbar.url.fg = fg4
c.colors.statusbar.url.error.fg = dark_red
c.colors.statusbar.url.hover.fg = bright_orange
c.colors.statusbar.url.success.http.fg = bright_red
c.colors.statusbar.url.success.https.fg = fg0
c.colors.statusbar.url.warn.fg = bright_purple


### Tabs

c.colors.tabs.bar.bg = bg0

c.colors.tabs.indicator.start = bright_blue
c.colors.tabs.indicator.stop = bright_aqua
c.colors.tabs.indicator.error = bright_red

c.colors.tabs.odd.fg = fg2
c.colors.tabs.odd.bg = bg2

c.colors.tabs.even.fg = fg2
c.colors.tabs.even.bg = bg3

c.colors.tabs.selected.odd.fg = fg2
c.colors.tabs.selected.odd.bg = bg0

c.colors.tabs.selected.even.fg = fg2
c.colors.tabs.selected.even.bg = bg0

c.colors.tabs.pinned.even.bg = bright_green
c.colors.tabs.pinned.even.fg = bg2

c.colors.tabs.pinned.odd.bg = bright_green
c.colors.tabs.pinned.odd.fg = bg2

c.colors.tabs.pinned.selected.even.bg = bg0
c.colors.tabs.pinned.selected.even.fg = fg2

c.colors.tabs.pinned.selected.odd.bg = bg0
c.colors.tabs.pinned.selected.odd.fg = fg2
