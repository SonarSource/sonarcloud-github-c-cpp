#!/bin/bash

source utils.sh

echo "Installation dir is '${INSTALL_DIR}'"

test ! -z "${INSTALL_DIR}"
check_status "Empty installation-dir specified"

if [[ ! -e "${INSTALL_DIR}" ]]; then
  mkdir -p "${INSTALL_DIR}"
  check_status "Failed to create non-existing installation-dir '${INSTALL_DIR}'"
fi  

ABSOLUTE_INSTALL_PATH=$(realpath "${INSTALL_DIR}")
echo "Absolute installation path is '${ABSOLUTE_INSTALL_PATH}'"

test  -d ${INSTALL_DIR}
check_status "Installation-dir '${INSTALL_DIR}' is not a directory (absolute path is '${ABSOLUTE_INSTALL_PATH}')"

test -r "${INSTALL_DIR}"
check_status "Installation-dir '${INSTALL_DIR}' is not readable (absolute path is '${ABSOLUTE_INSTALL_PATH}')"

test -w "${INSTALL_DIR}"
check_status "Installation-dir '${INSTALL_DIR}' is not writeable (absolute path is '${ABSOLUTE_INSTALL_PATH}')"

