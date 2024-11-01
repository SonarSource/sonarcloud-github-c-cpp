# Scan your C, C++, and Objective-C code with SonarQube Cloud [![QA](https://github.com/SonarSource/sonarcloud-github-c-cpp/actions/workflows/qa.yml/badge.svg)](https://github.com/SonarSource/sonarcloud-github-c-cpp/actions/workflows/qa.yml)

This SonarSource project, available as a GitHub Action, scans your C, C++, and Objective-C projects with SonarQube [Cloud](https://www.sonarsource.com/products/sonarcloud/).

![Logo](./images/SQ_Logo_Cloud_Dark_Backgrounds.png#gh-dark-mode-only)
![Logo](./images/SQ_Logo_Cloud_Light_Backgrounds.png#gh-light-mode-only)

SonarQube [Cloud](https://www.sonarsource.com/products/sonarcloud/) (formerly SonarCloud) is a widely used static analysis solution for continuous code quality and security inspection.

It helps developers detect coding issues in 30+ languages, frameworks, and IaC platforms, including Java, JavaScript, TypeScript, C#, Python, C, C++, and [many more](https://www.sonarsource.com/knowledge/languages/).

The solution also provides fix recommendations leveraging AI with Sonar's AI CodeFix capability.

## Requirements

* Create your account on SonarQube Cloud. [Sign up for free](https://www.sonarsource.com/products/sonarcloud/signup/?utm_medium=referral&utm_source=github&utm_campaign=sc-signup&utm_content=signup-sonarcloud-listing-x-x&utm_term=ww-psp-x) now if it's not already the case!
* The repository to analyze is set up on SonarQube Cloud. [Set it up](https://sonarcloud.io/projects/create) in just one click.

## Usage

Project metadata, including the location to the sources to be analyzed, must be declared in the file `sonar-project.properties` in the base directory:

```properties
sonar.organization=<replace with your SonarQube Cloud organization key>
sonar.projectKey=<replace with the key generated when setting up the project on SonarQube Cloud>

# relative paths to source directories. More details and properties are described
# at https://docs.sonarsource.com/sonarqube-cloud/advanced-setup/analysis-scope/
sonar.sources=.
```

The workflow, usually declared under `.github/workflows`, looks like:

```yaml
on:
  # Trigger analysis when pushing to your main branches, and when creating a pull request.
  push:
    branches:
      - main
      - master
      - develop
      - 'releases/**'
  pull_request:
      types: [opened, synchronize, reopened]

name: Main Workflow
jobs:
  sonarqube:
    runs-on: ubuntu-latest
    env:
      BUILD_WRAPPER_OUT_DIR: build_wrapper_output_directory # Directory where build-wrapper output will be placed
    steps:
    - uses: actions/checkout@v4
      with:
        # Disabling shallow clone is recommended for improving relevancy of reporting
        fetch-depth: 0
    - name: Install sonar-scanner and build-wrapper
      uses: sonarsource/sonarcloud-github-c-cpp@<action version> # Ex: v4.0.0, See the latest version at https://github.com/marketplace/actions/sonarcloud-scan-for-c-and-c
    - name: Run build-wrapper
      run: |
      # here goes your compilation wrapped with build-wrapper; See https://docs.sonarsource.com/sonarqube-cloud/advanced-setup/languages/c-family/overview/#analysis-steps-using-build-wrapper for more information
      # build-preparation steps
      # build-wrapper-linux-x86-64 --out-dir ${{ env.BUILD_WRAPPER_OUT_DIR }} build-command
    - name: Run sonar-scanner
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
      run: sonar-scanner --define sonar.cfamily.compile-commands="${{ env.BUILD_WRAPPER_OUT_DIR }}/compile_commands.json" #Consult https://docs.sonarcloud.io/advanced-setup/ci-based-analysis/sonarscanner-cli/ for more information and options
```

## Action parameters

You can change the `build-wrapper` and `sonar-scanner` installation path by using the optional input `installation-path` like this:

```yaml
uses: sonarsource/sonarcloud-github-c-cpp@<action version>
with:
  installation-path: my/custom/directory/path
```

Also, the absolute paths to the installed build-wrapper and sonar-scanner binaries are returned as outputs from the action.

Moreover, by default the action will cache sonar-scanner installation. However, you can disable caching by using the optional input: `cache-binaries` like this:
```yaml
uses: sonarsource/sonarcloud-github-c-cpp@<action version>
with:
  cache-binaries: false
```

See also [example configurations](https://github.com/sonarsource-cfamily-examples?q=gh-actions-sc&type=all&language=&sort=)

### Environment variables

- `SONAR_TOKEN` – **Required** this is the token used to authenticate access to SonarQube. You can read more about security tokens in the [documentation](https://docs.sonarsource.com/sonarqube-cloud/managing-your-account/managing-tokens/). You can set the `SONAR_TOKEN` environment variable in the "Secrets" settings page of your repository, or you can add them at the level of your GitHub organization (recommended).
- *`GITHUB_TOKEN` – Provided by Github (see [Authenticating with the GITHUB_TOKEN](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/authenticating-with-the-github_token)).*
- `SONAR_ROOT_CERT` – Holds an additional certificate (in PEM format) that is used to validate the certificate of a secured proxy to SonarQube Cloud. You can set the `SONAR_ROOT_CERT` environment variable in the "Secrets" settings page of your repository, or you can add them at the level of your GitHub organization (recommended).

Here is an example of how you can pass a certificate (in PEM format) to the Scanner truststore:

```yaml
- uses: sonarsource/sonarcloud-github-c-cpp@<action version>
  env:
    SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
    SONAR_ROOT_CERT: ${{ secrets.SONAR_ROOT_CERT }}
```

If your source code file names contain special characters that are not covered by the locale range of `en_US.UTF-8`, you can configure your desired locale like this:

```yaml
- uses: sonarsource/sonarcloud-github-c-cpp@<action version>
  env:
    SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
    LC_ALL: "ru_RU.UTF-8"
```

## Do not use this GitHub action if you are in the following situations

* You want to analyze code written in a language other than C or C++. Use the [SonarQube GitHub Action for SonarQube Server and Cloud](https://github.com/SonarSource/sonarqube-scan-action/) instead.
* You want to run the action on a 32-bits system - build wrappers support only 64-bits OS.

## Additional information

This action installs `coreutils` if run on macOS.

## Have question or feedback?

To provide feedback (requesting a feature or reporting a bug) please post on the [SonarSource Community Forum](https://community.sonarsource.com/tags/c/help/sc/9/github-actions).

## License

The action file and associated scripts and documentation in this project are released under the LGPLv3 License.
