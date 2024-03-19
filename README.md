# Analyze your code for free with SonarCloud

This SonarSource project, available as a GitHub Action, scans your C, C++, and Objective-C projects with SonarCloud, and helps developers produce 
[Clean Code](https://www.sonarsource.com/solutions/clean-code/?utm_medium=referral&utm_source=github&utm_campaign=clean-code&utm_content=sonarqube-scan-action).

<img src="./images/SonarCloud-72px.png">

[SonarCloud](https://www.sonarsource.com/products/sonarcloud/) is a widely used static analysis solution for continuous code quality and security inspection. 
It helps developers identify and fix issues in their code that could lead to bugs, vulnerabilities, or decreased development velocity.
SonarCloud supports the most popular programming languages, including Java, JavaScript, TypeScript, C#, Python, C, C++, and [many more](https://www.sonarsource.com/knowledge/languages/).


## Requirements

* Create your account on SonarCloud. Sign up for free now if it's not already the case! [SonarCloud Sign Up](https://www.sonarsource.com/products/sonarcloud/signup/?utm_medium=referral&utm_source=githubscan-ccpp&utm_campaign=sc-product&utm_content=signup-sonarcloud-listing-x-x&utm_term=ww-psp-x)
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
      uses: sonarsource/sonarcloud-github-c-cpp@v2
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
uses: sonarsource/sonarcloud-github-c-cpp@v2
with:
  installation-path: my/custom/directory/path
```
Also, the absolute paths to the installed build-wrapper and sonar-scanner binaries are returned as outputs from the action.

Moreover, by default the action will cache sonar-scanner installation. However, you can disable caching by using the optional input: `cache-binaries` like this:
```yaml
uses: sonarsource/sonarcloud-github-c-cpp@v2
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

Want to see more examples of SonarCloud in action? You can [explore current Open Source projects in SonarCloud](https://sonarcloud.io/explore/projects?sort=-analysis_date?utm_medium=referral&utm_source=githubscan-ccpp&utm_campaign=sc-product&utm_content=signup-sonarcloud-listing-x-x&utm_term=ww-psp-x) that are using the Clean as You Code methodology.

## Do not use this GitHub action if you are in the following situations

* You want to analyze code written in a language other than C or C++. Use [SonarCloud GitHub Action](https://github.com/SonarSource/sonarcloud-github-action/) instead
* You want to run the action on a 32-bits system - build wrappers support only 64-bits OS

## Additional information

This action installs `coreutils` if run on macOS

## Have question or feedback?

To provide feedback (requesting a feature or reporting a bug) please post on the [SonarSource Community Forum](https://community.sonarsource.com/) with the tag `sonarcloud`.

## License

The action file and associated scripts and documentation in this project are released under the LGPLv3 License.
