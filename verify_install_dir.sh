#!/bin/bash

check_status() {
  exit_status=$?
  if [ $exit_status -ne 0 ]; then
    echo "::error::$1"
    exit $exit_status
  fi
}

test ! -z "${INSTALL_DIR}"
check_status "Empty installation-dir specified"

mkdir -p "${INSTALL_DIR}"
check_status "Failed to create non-existing installation-dir '${INSTALL_DIR}'"

test -r "${INSTALL_DIR}"
check_status "Installation-dir '${INSTALL_DIR}' is not readable"

test -w "${INSTALL_DIR}"
check_status "Installation-dir '${INSTALL_DIR}' is not writeable"

