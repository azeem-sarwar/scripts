#!/bin/bash

# Exit script if any command fails
set -e

# Function to display usage instructions
usage() {
  echo "Usage: $0 <script_path> [command_name]"
  echo "  <script_path>   Path to the script you want to make global."
  echo "  [command_name]  (Optional) Name of the global command. Defaults to the script name without extension."
  exit 1
}

# Ensure the script path is provided
if [ -z "$1" ]; then
  echo "Error: Script path is required."
  usage
fi

SCRIPT_PATH=$1
COMMAND_NAME=$2

# Verify the script exists
if [ ! -f "$SCRIPT_PATH" ]; then
  echo "Error: File '$SCRIPT_PATH' not found."
  exit 1
fi

# Set the default command name if not provided
if [ -z "$COMMAND_NAME" ]; then
  COMMAND_NAME=$(basename "$SCRIPT_PATH" | sed 's/.sh$//') # Remove .sh extension
fi

# Target directory for global scripts
TARGET_DIR="/usr/local/bin"

# Copy the script to the target directory
echo "Copying '$SCRIPT_PATH' to '$TARGET_DIR/$COMMAND_NAME'..."
sudo cp "$SCRIPT_PATH" "$TARGET_DIR/$COMMAND_NAME"

# Make the script executable
echo "Making '$TARGET_DIR/$COMMAND_NAME' executable..."
sudo chmod +x "$TARGET_DIR/$COMMAND_NAME"

# Verify if the target directory is in the PATH
if ! echo "$PATH" | grep -q "$TARGET_DIR"; then
  echo "Adding '$TARGET_DIR' to your PATH..."
  SHELL_CONFIG="$HOME/.bashrc"
  if [ "$SHELL" = "/bin/zsh" ]; then
    SHELL_CONFIG="$HOME/.zshrc"
  fi
  echo "export PATH=\$PATH:$TARGET_DIR" >> "$SHELL_CONFIG"
  echo "Reloading shell configuration..."
  source "$SHELL_CONFIG"
fi

# Confirmation message
echo "The script is now globally accessible as '$COMMAND_NAME'."
echo "You can run it using the command: $COMMAND_NAME"
