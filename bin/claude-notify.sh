#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Parse hook event name
hook_event=$(echo "$input" | grep -o '"hook_event_name":"[^"]*"' | cut -d'"' -f4)

# Debug: log to file
echo "$(date): Hook called, event=$hook_event, ENTRYPOINT=$CLAUDE_CODE_ENTRYPOINT" >> /tmp/claude-hook-debug.log

# Only notify if running via CLI (not ACP like Zed/Tidewave)
if [ "$CLAUDE_CODE_ENTRYPOINT" != "cli" ]; then
  exit 0
fi

# Check if Ghostty is the frontmost application
frontmost_app=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null)

echo "$(date): Frontmost app: $frontmost_app" >> /tmp/claude-hook-debug.log

# Set message based on hook event
case "$hook_event" in
  "Stop")
    message="Task completed"
    ;;
  *)
    message="Ready for input"
    ;;
esac

# Check if we should notify
should_notify=true

if [ "$frontmost_app" = "ghostty" ]; then
  # Ghostty is focused - check if the Claude tab is active
  window_title=$(osascript -e 'tell application "System Events" to tell process "ghostty" to get name of window 1' 2>/dev/null)
  echo "$(date): Ghostty window title: $window_title" >> /tmp/claude-hook-debug.log

  # Claude Code tabs have ✳ prefix, or may contain "claude" in title
  # Convert to lowercase for case-insensitive check
  title_lower=$(echo "$window_title" | tr '[:upper:]' '[:lower:]')

  if [[ "$window_title" == *"✳"* ]] || [[ "$title_lower" == *"claude"* ]]; then
    should_notify=false
    echo "$(date): Claude tab focused, skipping notification" >> /tmp/claude-hook-debug.log
  else
    echo "$(date): Ghostty focused but different tab active" >> /tmp/claude-hook-debug.log
  fi
fi

if [ "$should_notify" = true ]; then
  echo "$(date): Sending notification: $message" >> /tmp/claude-hook-debug.log
  terminal-notifier -title "Claude Code" -message "$message" \
    -sender com.anthropic.claudefordesktop \
    -group claude-code
  echo "$(date): Notification sent, exit code: $?" >> /tmp/claude-hook-debug.log
fi
