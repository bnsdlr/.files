config.load_autoconfig(False)

config.bind('go', ':scroll-to-perc 0')
c.search.incremental = False
config.source('vague.py')

c.colors.webpage.darkmode.enabled = True
c.colors.webpage.darkmode.policy.page = 'always'
c.colors.webpage.preferred_color_scheme = 'dark'

css = "~/.config/qutebrowser/my.css"
config.set("content.user_stylesheets", [css])
config.bind(",n", f'config-cycle content.user_stylesheets ["{css}"] []')

