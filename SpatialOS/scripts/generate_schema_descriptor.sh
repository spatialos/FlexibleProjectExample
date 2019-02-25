#!/usr/bin/env bash

# This script generates a schema descriptor from the project schema

set -e -x
pushd "$( dirname "${BASH_SOURCE[0]}" )"
source ./utils.sh

# Download the dependenties in case they are not present
if [ ! -d "${TOOLS_DIR}/schema_compiler" ] || [ ! -d "${SCHEMA_DIR}/improbable" ]; then
  ./download_dependencies.sh
fi

mkdir -p "${SCHEMA_BIN_DIR}"
# Generate a schema descriptor from the project schema using the schema compiler
"${TOOLS_DIR}"/schema_compiler/schema_compiler \
  --schema_path="${SCHEMA_DIR}" \
  --descriptor_set_out="${SCHEMA_BIN_DIR}"/schema.descriptor \
  --load_all_schema_on_schema_path \
  "${SCHEMA_DIR}"/*.schema \
  "${SCHEMA_DIR}"/improbable/*.schema

popd
