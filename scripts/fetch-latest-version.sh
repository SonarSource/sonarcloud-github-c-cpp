#!/bin/bash

SONAR_SCANNER_VERSION=$(curl -H "Accept: application/vnd.github+json" \
  https://api.github.com/repos/SonarSource/sonar-scanner-cli/releases/latest | jq -r '.tag_name')
echo sonar-scanner-version=${SONAR_SCANNER_VERSION} 
