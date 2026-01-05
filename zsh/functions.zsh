##
# Reloads zsh configs
#
function reload () {
  source ~/.zshrc
}

##
# Utility to make it easier to run a Livebook app server for dev purposes
#
# Usage: lb_app_server [env]
# env: Either 'prod' or 'dev'. Defaults to 'dev' if not specified
#

function lb_app_server() {
  # Default to prod if no environment is specified
  local env=${1:-dev}
  # Get the string that should be copied from the "App server setup" screen inside Livebook
  input_string=$(pbpaste 2>/dev/null || xclip -o 2>/dev/null || xsel --clipboard --output 2>/dev/null)

  if [[ -z "$input_string" ]]; then
    echo "Error: Unable to retrieve clipboard content."
    return 1
  fi

  # Extract the values for LIVEBOOK_TEAMS_KEY and LIVEBOOK_TEAMS_AUTH
  livebook_teams_key=$(echo "$input_string" | grep -oE 'LIVEBOOK_TEAMS_KEY="[^"]*"' | cut -d'"' -f2)
  livebook_teams_auth=$(echo "$input_string" | grep -oE 'LIVEBOOK_TEAMS_AUTH="[^"]*"' | cut -d'"' -f2)

  if [[ -z "$livebook_teams_key" || -z "$livebook_teams_auth" ]]; then
    echo "Error: Unable to extract LIVEBOOK_TEAMS_KEY or LIVEBOOK_TEAMS_AUTH."
    return 1
  fi

  # Set environment-specific variables
  local env_vars=""
  if [[ "$env" == "dev" ]]; then
    env_vars="MIX_ENV=dev LIVEBOOK_TOKEN_ENABLED=false"
  else
    env_vars="MIX_ENV=prod"
  fi

  # Define the command
  command="LIVEBOOK_AGENT_NAME=default \\
  LIVEBOOK_TEAMS_KEY=$livebook_teams_key \\
  LIVEBOOK_TEAMS_AUTH=$livebook_teams_auth \\
  LIVEBOOK_SECRET_KEY_BASE=ZQ0zaHN0OsioIhSEZnCVDBvd1MKl89R_tbISupofY7imiZLhInKT27uw12H-yuC8 \\
  LIVEBOOK_COOKIE=secret \\
  LIVEBOOK_PORT=4500 \\
  LIVEBOOK_IFRAME_PORT=4501 \\
  LIVEBOOK_TEAMS_URL=http://localhost:4100 \\
  LIVEBOOK_DATA_PATH=/Users/hugobarauna/src/tmp/livebook_data_paths/test/prod-app-server \\
  LIVEBOOK_LOG_LEVEL=debug \\
  $env_vars \\
  mix phx.server"

  # Set terminal title
  print -Pn '\e]0;Livebook (app server): %1~\a'

  # Echo the command
  echo "Running this command:"
  echo "$command"

  # Add the multiline command to the shell history
  print -s "$(echo $command | tr -d '\\\n')"

  # Run the command
  eval $command
}
