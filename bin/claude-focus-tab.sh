#!/bin/bash

target_dir="$1"

osascript <<APPLESCRIPT
tell application "Ghostty"
    activate
    -- Try matching by working directory first (most precise)
    if "$target_dir" is not "" then
        set matches to every terminal whose working directory is "$target_dir"
        if (count of matches) > 0 then
            focus item 1 of matches
            return
        end if
    end if
    -- Fallback: find by tab name
    repeat with w in windows
        repeat with t in tabs of w
            set tabName to name of t
            if tabName contains "✳" or tabName contains "claude" then
                select tab t
                activate window w
                return
            end if
        end repeat
    end repeat
end tell
APPLESCRIPT
