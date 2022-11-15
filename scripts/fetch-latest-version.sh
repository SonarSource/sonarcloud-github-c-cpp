#!/bin/bash

source "$(dirname -- "$0")/utils.sh"

SONAR_SCANNER_VERSION=$(curl -H "Accept: application/vnd.github+json" \
  https://api.github.com/repos/SonarSource/sonar-scanner-cli/releases/latest | jq -r '.tag_name')
check_status "Failed to fetch latest sonar-scanner version from GitHub API"

echo sonar-scanner-version=${SONAR_SCANNER_VERSION} 
