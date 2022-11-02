SONAR_SCANNER_VERSION="$(curl \
      -H "Accept: application/vnd.github+json" \
        https://api.github.com/repos/SonarSource/sonar-scanner-cli/releases/latest | jq '.tag_name') \
        echo "$SONAR_SCANNER_VERSION"
