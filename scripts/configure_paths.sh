#!/bin/bash

if [[ ${ARCH} != "X64" && ! (${ARCH} == "ARM64" && (${OS} == "macOS" || ${OS} == "Linux")) ]]; then 
  echo "::error::Architecture '${ARCH}' is unsupported by build-wrapper"
  exit 1
fi

case ${OS} in
  Windows)
    SONAR_SCANNER_SUFFIX="-windows"
    BUILD_WRAPPER_SUFFIX="win-x86"
    SONAR_SCANNER_NAME="sonar-scanner.bat"
    BUILD_WRAPPER_NAME="build-wrapper-win-x86-64.exe"
    SONAR_SCANNER_URL="${SONAR_SCANNER_URL_WINDOWS}"
    SONAR_SCANNER_SHA="${SONAR_SCANNER_SHA_WINDOWS}"
    ;;
  Linux)  
    case ${ARCH} in
      X64)
        SONAR_SCANNER_SUFFIX="-linux"
        BUILD_WRAPPER_SUFFIX="linux-x86"
        BUILD_WRAPPER_NAME="build-wrapper-linux-x86-64"
        SONAR_SCANNER_URL="${SONAR_SCANNER_URL_LINUX}"
        SONAR_SCANNER_SHA="${SONAR_SCANNER_SHA_LINUX}"
        ;;
      ARM64)
        SONAR_SCANNER_SUFFIX=""
        BUILD_WRAPPER_SUFFIX="linux-aarch64"
        BUILD_WRAPPER_NAME="build-wrapper-linux-aarch64"
        SONAR_SCANNER_URL="${SONAR_SCANNER_URL_UNIVERSAL}"
        SONAR_SCANNER_SHA="${SONAR_SCANNER_SHA_UNIVERSAL}"
        ;;
    esac
    SONAR_SCANNER_NAME="sonar-scanner"
    ;;
  macOS)
    SONAR_SCANNER_SUFFIX="-macosx"
    BUILD_WRAPPER_SUFFIX="macosx-x86"
    SONAR_SCANNER_NAME="sonar-scanner"
    BUILD_WRAPPER_NAME="build-wrapper-macosx-x86"
    SONAR_SCANNER_URL="${SONAR_SCANNER_URL_MACOSX}"
    SONAR_SCANNER_SHA="${SONAR_SCANNER_SHA_MACOSX}"
    ;;
  *)
    echo "::error::Unsupported runner OS '${OS}'"
    exit 1
    ;;
esac


echo "sonar-scanner-url=${SONAR_SCANNER_URL}"
echo "sonar-scanner-sha=${SONAR_SCANNER_SHA}"

SONAR_SCANNER_DIR="${INSTALL_PATH}/sonar-scanner-${SONAR_SCANNER_VERSION}${SONAR_SCANNER_SUFFIX}"
echo "sonar-scanner-dir=${SONAR_SCANNER_DIR}"
echo "sonar-scanner-bin=${SONAR_SCANNER_DIR}/bin/${SONAR_SCANNER_NAME}"

BUILD_WRAPPER_DIR="${INSTALL_PATH}/build-wrapper-${BUILD_WRAPPER_SUFFIX}"
echo "build-wrapper-url=${SONAR_HOST_URL}/static/cpp/build-wrapper-${BUILD_WRAPPER_SUFFIX}.zip"
echo "build-wrapper-dir=${BUILD_WRAPPER_DIR}"
echo "build-wrapper-bin=${BUILD_WRAPPER_DIR}/${BUILD_WRAPPER_NAME}"

