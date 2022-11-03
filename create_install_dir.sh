#!/bin/bash

source utils.sh

echo "Installation dir is '${INSTALL_DIR}'"

test ! -z "${INSTALL_DIR}"
check_status "Empty installation-dir specified"

mkdir -p "${INSTALL_DIR}"
check_status "Failed to create non-existing installation-dir '${INSTALL_DIR}'"

test -r "${INSTALL_DIR}"
check_status "Installation-dir '${INSTALL_DIR}' is not readable (absolute path is '$(realpath "${INSTALL_DIR}")')"

test -w "${INSTALL_DIR}"
check_status "Installation-dir '${INSTALL_DIR}' is not writeable (absolute path is '$(realpath "${INSTALL_DIR}")')"

