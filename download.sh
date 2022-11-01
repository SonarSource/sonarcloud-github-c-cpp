#!/bin/bash

VERIFY_CORRECTNESS=false

help() {
  cat <<EOF
Usage: ./download [-v]
-h              Display help
-v              Verify correctness of a download with SHA256 checksum; Optional
EOF
}

parse_arguments() {
  while getopts "hv" arg; do
    case $arg in
    v)
      VERIFY_CORRECTNESS=true
      echo "Verify correctness is set to true"
      ;;
    ?)
      help
      exit 0
      ;;
    esac
  done
}

check_status() {
  exit_status=$?
  if [ $exit_status -ne 0 ]; then
    echo "::error::$1"
    exit $exit_status
  fi
}

verify_download_correctness() {
  echo "Checking download correctness with '$SHA_DOWNLOAD_URL'"
  curl -sSLo "${TMP_ZIP_PATH}.sha256" "${SHA_DOWNLOAD_URL}"
  check_status "Failed to download '$SHA_DOWNLOAD_URL'"

  echo "  ${TMP_ZIP_PATH}" >>${TMP_ZIP_PATH}.sha256

  sha256sum -c ${TMP_ZIP_PATH}.sha256
  check_status "Checking sha256 failed"
}

download() {
  echo "Downloading '${DOWNLOAD_URL}'"
  mkdir -p "${INSTALL_DIR}"
  check_status "Failed to create ${INSTALL_DIR}"
  curl -sSLo "${TMP_ZIP_PATH}" "${DOWNLOAD_URL}"
  check_status "Failed to download '${DOWNLOAD_URL}'"
}

decompress() {
  echo "Decompressing"
  unzip -o -d "${INSTALL_DIR}" "${TMP_ZIP_PATH}"
  check_status "Failed to unzip the archive into '${INSTALL_DIR}'"
}

####################################################################################

parse_arguments $@
download
if [ "$VERIFY_CORRECTNESS" = true ]; then
  verify_download_correctness
fi
decompress
