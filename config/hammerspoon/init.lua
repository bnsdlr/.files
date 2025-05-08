hs = hs

hs.hotkey.bind({ "cmd" }, "1", function()
    hs.application.launchOrFocus("Ghostty")
end)

hs.hotkey.bind({ "cmd" }, "2", function()
    hs.application.launchOrFocus("Safari")
end)

hs.hotkey.bind({ "cmd" }, "3", function()
    hs.application.launchOrFocus("Music")
end)

hs.hotkey.bind({ "cmd" }, "4", function()
    hs.application.launchOrFocus("Finder")
end)

hs.hotkey.bind({ "option" }, "A", function()
    local window = hs.window.focusedWindow()
    window:maximize(0)
end)

