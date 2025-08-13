#!/bin/bash
# Watches lib/ and test/, runs `mix test --stale`, and macOS-notifies pass/fail.
# Usage: just run `watch_tests` inside your Elixir project.

set -euo pipefail

notify() {
  local title="$1" msg="${2:-}"
  # macOS native notification
  osascript -e "display notification \"$msg\" with title \"$title\"" >/dev/null 2>&1 || true
}

run_tests() {
  printf "Running tests...\n"

  # Run tests and capture both output and exit status using PIPESTATUS
  # Force colors with --color to preserve them when piping to tee
  set +e  # Temporarily disable exit on error to capture status
  mix test --stale --color 2>&1 | tee /tmp/test_output.txt
  local status=${PIPESTATUS[0]}
  set -e  # Re-enable exit on error

  # Check if there are compilation errors
  if grep -q "Compilation error\|CompileError" /tmp/test_output.txt; then
    notify "🔶 Compilation Error" "Fix compilation errors to run tests"
    # echo "🔶 Compilation errors detected"
  elif [ $status -eq 0 ]; then
    notify "🟢 Tests green" "All tests passed"
    # echo "✅ Tests passed"
  else
    notify "🔴 Tests red" "Some tests failed"
    # echo "❌ Tests failed"
  fi

  # Always return 0 so the script doesn't exit on test failures
  return 0
}

# first run immediately
run_tests

# then re-run on changes (coalesced)
echo "👁️  Watching lib/ and test/ for changes..."
trap 'echo; echo "Bye!"; exit 0' INT TERM

fswatch -o -r lib test | while read -r num_events; do
  echo "🔍 Detected $num_events change(s), running tests..."
  # debounce a bit to avoid flapping on editor temp files
  sleep 0.15
  run_tests
done

echo "⚠️  fswatch exited unexpectedly"
