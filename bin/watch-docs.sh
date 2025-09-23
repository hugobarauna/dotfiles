#!/bin/bash

# Exit on any error
set -e

# Function to cleanup background processes on exit
cleanup() {
    echo "Cleaning up..."
    # Kill all background jobs
    jobs -p | xargs -r kill
    exit 0
}

# Set up trap to call cleanup on Ctrl+C (SIGINT) or script exit
trap cleanup SIGINT EXIT

echo "Step 1: Generating initial docs..."
mix docs

echo "Step 2 & 3: Starting file watcher and browser-sync..."

# Start fswatch in background
fswatch mix.exs docs/ | xargs -I {} mix docs &

# Start browser-sync in background
browser-sync start --server doc --files "doc/*" &

echo "Docs watcher is running. Press Ctrl+C to stop all processes."

# Wait for background processes
wait
