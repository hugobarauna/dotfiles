##
# Reloads zsh configs
#
function reload () {
  source ~/.zshrc
}

##
# Utility to make it easier to run a Livebook app server for dev purposes
#
function lb_app_server() {
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

  # Define the command
  command="LIVEBOOK_AGENT_NAME=default \\
  LIVEBOOK_TEAMS_KEY=$livebook_teams_key \\
  LIVEBOOK_TEAMS_AUTH=$livebook_teams_auth \\
  LIVEBOOK_SECRET_KEY_BASE=ZQ0zaHN0OsioIhSEZnCVDBvd1MKl89R_tbISupofY7imiZLhInKT27uw12H-yuC8 \\
  LIVEBOOK_COOKIE=c_OD6yogAKqa5xCfkeYirxd4trWl52ZCAMuxcLifhjd1hp8P9ksx5r \\
  LIVEBOOK_PORT=4200 \\
  LIVEBOOK_IFRAME_PORT=4201 \\
  LIVEBOOK_TEAMS_URL=http://localhost:4100 \\
  LIVEBOOK_DATA_PATH=/Users/hugobarauna/src/tmp/livebook_data_paths/test/prod-app-server \\
  LIVEBOOK_LOG_LEVEL=debug \\
  MIX_ENV=prod \\
  mix phx.server"

  # Echo the command
  echo "Running this command:"
  echo "$command"

  # Add the multiline command to the shell history
  print -s "$(echo $command | tr -d '\\\n')"

  # Run the command
  eval $command
}
