#!/bin/bash

input=$(cat)
hook_event=$(echo "$input" | grep -o '"hook_event_name":"[^"]*"' | cut -d'"' -f4)

echo "$(date): Hook called, event=$hook_event, ENTRYPOINT=$CLAUDE_CODE_ENTRYPOINT" >> /tmp/claude-hook-debug.log

# Only notify if running via CLI (not ACP like Zed/Tidewave)
if [ "$CLAUDE_CODE_ENTRYPOINT" != "cli" ]; then
  exit 0
fi

case "$hook_event" in
  "Stop") message="Task completed" ;;
  *) message="Ready for input" ;;
esac

# Use Ghostty's native AppleScript for precise tab detection
claude_tab_status=$(osascript 2>/dev/null <<'APPLESCRIPT'
tell application "System Events"
    if not (exists process "ghostty") then return "no-ghostty"
    if not (frontmost of process "ghostty") then return "not-focused"
end tell
tell application "Ghostty"
    try
        set tabName to name of selected tab of front window
        if tabName contains "✳" or tabName contains "claude" then
            return "claude-focused"
        end if
    end try
end tell
return "other-tab"
APPLESCRIPT
)

echo "$(date): Tab status: $claude_tab_status" >> /tmp/claude-hook-debug.log

if [ "$claude_tab_status" = "claude-focused" ]; then
  echo "$(date): Claude tab focused, skipping notification" >> /tmp/claude-hook-debug.log
  exit 0
fi

echo "$(date): Sending notification: $message" >> /tmp/claude-hook-debug.log
terminal-notifier -title "Claude Code" -message "$message" \
  -group claude-code \
  -execute "$HOME/bin/claude-focus-tab.sh '${PWD//\'/\'\\\'\'}'"
echo "$(date): Notification sent, exit code: $?" >> /tmp/claude-hook-debug.log
