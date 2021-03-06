#!/bin/sh -l

set -e

if [ -z "$ACCESS_TOKEN" ] && [ -z "$GITHUB_TOKEN" ]
then
  echo "You must provide the action with either a Personal Access Token or the GitHub Token secret in order to deploy."
  exit 1
fi

FOLDER=build

# Installs Git
apt-get update && \
apt-get install -y git && \

# Directs the action to the the Github workspace.
cd $GITHUB_WORKSPACE && \

# Clone repository
git clone https://${ACCESS_TOKEN:-"x-access-token:$GITHUB_TOKEN"}@github.com/${GITHUB_REPOSITORY}.git . && \

# Checks out to master.
git checkout main && \

# Install dependencies
echo "Installing dependencies.." && \
eval "npm install" && \

# Builds the project
echo "Running build scripts.." && \
if [ -z "$BUILD_ENV" ]
then
  eval "npm run build"
else
  eval "npm run build:$BUILD_ENV"
fi
