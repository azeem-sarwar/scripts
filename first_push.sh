#!/bin/bash

# Exit script if any command fails
set -e

# Function to display usage instructions
usage() {
  echo "Usage: $0 <repository_url>"
  exit 1
}

# Check if the repository URL is provided
if [ -z "$1" ]; then
  echo "Error: Repository URL is required."
  usage
fi

REPO_URL=$1

# Initialize a Git repository if not already initialized
if [ ! -d ".git" ]; then
  echo "Initializing Git repository..."
  git init
else
  echo "Git repository already initialized."
fi

# Add all files to the staging area
echo "Adding files to the staging area..."
git add .

# Commit changes
echo "Committing changes..."
read -p "Enter commit message: " COMMIT_MESSAGE
if [ -z "$COMMIT_MESSAGE" ]; then
  COMMIT_MESSAGE="Initial commit"
fi
git commit -m "$COMMIT_MESSAGE"

# Add the remote repository
echo "Adding remote repository..."
git remote add origin "$REPO_URL" || git remote set-url origin "$REPO_URL"

# Push code to the remote repository
echo "Pushing code to the remote repository..."
git branch -M main
git push -u origin main

echo "Code successfully pushed to $REPO_URL"
