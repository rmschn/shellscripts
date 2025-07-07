#!/bin/bash

# Usage:
# ./setup_reverse_ssh_tunnel.sh <remote_user> <remote_host> <remote_port> <local_host> <local_port> [ssh_key_file]
# Example:
# ./setup_reverse_ssh_tunnel.sh user example.com 9000 localhost 22 ~/.ssh/id_rsa

# Arguments
REMOTE_USER="$1"
REMOTE_HOST="$2"
REMOTE_PORT="$3"
LOCAL_HOST="$4"
LOCAL_PORT="$5"
SSH_KEY_FILE="$6"

# Check required arguments
if [[ -z "$REMOTE_USER" || -z "$REMOTE_HOST" || -z "$REMOTE_PORT" || -z "$LOCAL_HOST" || -z "$LOCAL_PORT" ]]; then
  echo "Usage: $0 <remote_user> <remote_host> <remote_port> <local_host> <local_port> [ssh_key_file]"
  exit 1
fi

# Build SSH command
SSH_CMD="ssh -N -R ${REMOTE_PORT}:${LOCAL_HOST}:${LOCAL_PORT} ${REMOTE_USER}@${REMOTE_HOST}"

if [[ -n "$SSH_KEY_FILE" ]]; then
  SSH_CMD="ssh -i $SSH_KEY_FILE -N -R ${REMOTE_PORT}:${LOCAL_HOST}:${LOCAL_PORT} ${REMOTE_USER}@${REMOTE_HOST}"
fi

echo "Setting up reverse SSH tunnel:"
echo "Remote: ${REMOTE_HOST}:${REMOTE_PORT} --> Local: ${LOCAL_HOST}:${LOCAL_PORT}"
echo "Running: $SSH_CMD"

# Run the SSH tunnel (in the background)
$SSH_CMD &
TUNNEL_PID=$!

echo "Tunnel established. SSH process PID: $TUNNEL_PID"

# Optional: Trap to cleanup when the script exits
trap "echo 'Killing SSH tunnel...'; kill $TUNNEL_PID" SIGINT SIGTERM EXIT

# Wait for the SSH tunnel process to finish
wait $TUNNEL_PID