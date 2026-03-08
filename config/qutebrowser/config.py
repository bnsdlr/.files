config.load_autoconfig(False)

c.window.hide_decoration = True
c.completion.shrink = True

config.bind('go', ':scroll-to-perc 0')
config.bind('<space>h', ':home')
config.bind('<space>p', ':tab-pin')
config.bind('<space>s', ':config-source')

c.colors.webpage.darkmode.enabled = True
c.colors.webpage.darkmode.policy.page = 'always'
c.colors.webpage.preferred_color_scheme = 'dark'

css = "~/.config/qutebrowser/my.css"
config.set("content.user_stylesheets", [css])
config.bind("<space>n", f'config-cycle content.user_stylesheets ["{css}"] []')

c.url.default_page = "about:blank"
c.url.start_pages = ["about:blank"]

config.source('vague.py')
