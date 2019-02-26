#!/usr/bin/env bash

# This script converts a binary snapshot file to its text format representation
# Usage: convert_snapshot.sh <binary snapshot file name, optional, default value: "default.snapshot"> <text snapshot file name, optional, default value: "default.txt">

set -e -x
pushd "$( dirname "${BASH_SOURCE[0]}" )"
source ./utils.sh

SNAPSHOT_BIN_FILE=${1:-"default.snapshot"}
SNAPSHOT_TEXT_FILE=${2:-"default.txt"}

# Download the dependenties in case they are not present
if [ ! -d "${TOOLS_DIR}/snapshot_converter" ]; then
  ./download_dependencies.sh
fi

# Generate a schema descriptor in case it is not present
if [ ! -d "${SCHEMA_BIN_DIR}" ]; then
  ./generate_schema_descriptor.sh
fi

pushd "${SNAPSHOTS_DIR}"
"${TOOLS_DIR}"/snapshot_converter/snapshot_converter \
  convert \
  "${SNAPSHOT_BIN_FILE}" \
  binary \
  "${SNAPSHOT_TEXT_FILE}" \
  text \
  "${SCHEMA_BIN_DIR}"/schema.descriptor \
  "${TOOLS_DIR}"/snapshot_converter/snapshot.descriptor
popd

popd
