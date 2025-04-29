#!/bin/bash

# ================================================
#  Upload Azure Publish Profile to GitHub Secrets
# ================================================

# Load base environment from .env
if [[ -f .env ]]; then
  source .env
else
  echo " .env file not found."
  echo "Please create a .env file with the required variables."
  exit 1
fi
 

read -p "GitHub repo URL [default: $GITHUB_REPO]: " GITHUB_REPO_INPUT
GITHUB_REPO=${GITHUB_REPO_INPUT:-$GITHUB_REPO}

read -p "Path to publish profile file [default: .env_prod_fastapi]: " ENV_FILE_INPUT
ENV_FILE=${ENV_FILE_INPUT:-.env_prod_fastapi}

# Validate file exists
if [[ ! -f "$ENV_FILE" ]]; then
  echo " File not found: $ENV_FILE"
  exit 1
fi

# Extract GitHub repo owner and name
REPO_NAME=$(basename "$GITHUB_REPO" .git)
GITHUB_OWNER=$(basename "$(dirname "$GITHUB_REPO")")
REPO_FULL="$GITHUB_OWNER/$REPO_NAME"

# Push secret to GitHub
echo " Uploading AZURE_PUBLISH_PROFILE from $ENV_FILE to $REPO_FULL"
gh secret set AZURE_PUBLISH_PROFILE \
  -f "$ENV_FILE" \
  -R "$REPO_FULL"

echo " AZURE_PUBLISH_PROFILE secret set successfully."
