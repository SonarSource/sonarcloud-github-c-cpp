# Scan your C and C++ code with SonarCloud

Using this GitHub Action, scan your code with [SonarCloud](https://sonarcloud.io/) to detect bugs, vulnerabilities and code smells in C and C++!

This GitHub action installs the latest versions of `sonar-scanner` and `build-wrapper` required for [C and C++ SonarCloud analysis](https://docs.sonarcloud.io/advanced-setup/languages/c-c-objective-c/) making the workflow simpler.
For use with other programming languages see [SonarCloud GitHub Action](https://github.com/SonarSource/sonarcloud-github-action/)

<img src="./images/SonarCloud-72px.png">

SonarCloud is the leading product for Continuous Code Quality & Code Security online, totally free for open-source projects. It supports all major programming languages, including Java, JavaScript, TypeScript, C#, C and C++ and many more. If your code is closed source, SonarCloud also offers a paid plan to run private analyses.


## Requirements

* Have an account on SonarCloud. [Sign up for free now](https://sonarcloud.io/sessions/init/github) if it's not already the case!
* The repository to analyze is set up on SonarCloud. [Set it up](https://sonarcloud.io/projects/create) in just one click.

## Usage


Project metadata, including the location to the sources to be analyzed, must be declared in the file `sonar-project.properties` in the base directory:

```properties
sonar.organization=<replace with your SonarCloud organization key>
sonar.projectKey=<replace with the key generated when setting up the project on SonarCloud>

# relative paths to source directories. More details and properties are described
# in https://sonarcloud.io/documentation/project-administration/narrowing-the-focus/
sonar.sources=.
```

The workflow, usually declared in `.github/workflows/build.yml`, looks like:

```yaml
on:
  # Trigger analysis when pushing in master or pull requests, and when creating
  # a pull request.
  push:
    branches:
      - master
  pull_request:
      types: [opened, synchronize, reopened]
name: Main Workflow
jobs:
  sonarcloud:
    runs-on: ubuntu-latest
    env:
      BUILD_WRAPPER_OUT_DIR: build_wrapper_output_directory # Directory where build-wrapper output will be placed
    steps:
    - uses: actions/checkout@v3
      with:
        # Disabling shallow clone is recommended for improving relevancy of reporting
        fetch-depth: 0
    - name:  Install sonar-scanner and build-wrapper
      uses: sonarsource/sonarcloud-github-c-cpp@v1
    - name: Run build-wrapper
      run: |
      #here goes your compilation wrapped with build-wrapper; See https://docs.sonarcloud.io/advanced-setup/languages/c-c-objective-c/#analysis-steps-using-build-wrapper for more information
      # build-preparation steps
      # build-wrapper-linux-x86-64 --out-dir ${{ env.BUILD_WRAPPER_OUT_DIR }} build-command
    - name: Run sonar-scanner
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
      run: sonar-scanner --define sonar.cfamily.build-wrapper-output="${{ env.BUILD_WRAPPER_OUT_DIR }}" #Consult https://docs.sonarcloud.io/advanced-setup/ci-based-analysis/sonarscanner-cli/ for more information and options
```

You can change the `build-wrapper` and `sonar-scanner` installation path by using the optional input `installation-path` like this:

```yaml
uses: sonarsource/sonarcloud-github-c-cpp@v1
with:
  installation-path: my/custom/directory/path
```
Also, the absolute paths to the installed build-wrapper and sonar-scanner binaries are returned as outputs from the action.

Moreover, by default the action will cache sonar-scanner installation. However, you can disable caching by using the optional input: `cache-binaries` like this:
```yaml
uses: sonarsource/sonarcloud-github-c-cpp@v1
with:
  cache-binaries: false
```

See also [example configurations](https://github.com/sonarsource-cfamily-examples?q=gh-actions-sc&type=all&language=&sort=)

### Secrets

Following secrets are required for successful invocation of sonar-scanner: 
- `SONAR_TOKEN` – **Required** this is the token used to authenticate access to SonarCloud. You can generate a token on your [Security page in SonarCloud](https://sonarcloud.io/account/security/). You can set the `SONAR_TOKEN` environment variable in the "Secrets" settings page of your repository.
- *`GITHUB_TOKEN` – Provided by Github (see [Authenticating with the GITHUB_TOKEN](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/authenticating-with-the-github_token)).*

## Example of pull request analysis

<img src="./images/SonarCloud-analysis-in-Checks.png">

## Do not use this GitHub action if you are in the following situations

* You want to analyze code written in a language other than C or C++. Use [SonarCloud GitHub Action](https://github.com/SonarSource/sonarcloud-github-action/) instead
* You want to run the action on a 32-bits system - build wrappers support only 64-bits OS

## Additional information

This action installs `coreutils` if run on macOS

## Have question or feedback?

To provide feedback (requesting a feature or reporting a bug) please post on the [SonarSource Community Forum](https://community.sonarsource.com/) with the tag `sonarcloud`.

## License

The action file and associated scripts and documentation in this project are released under the LGPLv3 License.
