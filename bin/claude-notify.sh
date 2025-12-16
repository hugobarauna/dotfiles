#!/bin/bash

# Only notify if running via CLI (not ACP like Zed/Tidewave)
if [ "$CLAUDE_CODE_ENTRYPOINT" = "cli" ]; then
  terminal-notifier -title "Claude Code" -message "Ready for input" -sender com.anthropic.claudefordesktop
fi
