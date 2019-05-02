#!/bin/bash

DEFAULT_PORT=8000
PORT=$DEFAULT_PORT


# Check to see if php is enabled on the system
if ! command -v php >/dev/null 2>&1; then
  echo -e "!!      PHP has not been installed, unable to start local server."
  echo -e "\texiting..."
  exit 1
fi

# Attempt to read the port from the arguments
if [[ "$#" -ge 1 ]]; then
  PORT="$1"

  # Check validity
  if ! [[ "$PORT" =~ ^[0-9][0-9][0-9][0-9]$ ]]; then
    echo "Invalid port specified! [$PORT], using default."
    PORT=$DEFAULT_PORT
  fi
fi

ADDRESS="localhost:$PORT"

echo "Starting server on port: $PORT"
php -S $ADDRESS


