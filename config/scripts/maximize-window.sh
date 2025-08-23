#!/bin/bash

osascript -e 'tell application "Finder"
    set screenBounds to bounds of window of desktop
    set screenWidth to item 3 of screenBounds
    set screenHeight to item 4 of screenBounds
end tell

tell application "System Events"
    -- Account for menu bar (typically 24 pixels on macOS)
    set windowHeight to screenHeight - 24

    set frontApp to name of first application process whose frontmost is true
    tell application process frontApp
        tell front window
            set position to {0, 24} -- Start below menu bar
            set size to {screenWidth, windowHeight}
        end tell
    end tell
end tell'

