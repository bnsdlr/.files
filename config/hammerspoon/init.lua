hs = hs

-- 
-- App launcher
--

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

--
-- Windows
--

local margin = 8
local almost_maximize_percentage = 0.9

hs.hotkey.bind({ "option" }, "f", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local max = win:screen():frame()

    f.x = max.x + margin
    f.y = max.y + margin
    f.w = max.w - margin * 2
    f.h = max.h - margin * 2
    win:setFrame(f, 0)
end)

hs.hotkey.bind({ "option" }, "a", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local max = win:screen():frame()

    local w = max.w * almost_maximize_percentage
    local h = max.h * almost_maximize_percentage

    f.x = max.x + (max.w - w) / 2
    f.y = max.y + (max.h - h) / 2
    f.w = w
    f.h = h
    win:setFrame(f, 0)
end)
