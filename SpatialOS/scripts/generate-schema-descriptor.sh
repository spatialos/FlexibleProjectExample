#!/usr/bin/env bash

set -e -x
pushd "../"

BUILD_DIR="$1"
PACKAGES_DIR="$2"

SCHEMA_DIR="${BUILD_DIR}"/SpatialOS/schema
SCHEMA_BIN_DIR="${BUILD_DIR}"/SpatialOS/schema_out
OUT_DIR="${SCHEMA_BIN_DIR}"/bin/generated/csharp

# Generate C# code from the schemas:
mkdir -p "${OUT_DIR}"
"${PACKAGES_DIR}"/schema_compiler/schema_compiler \
  --schema_path="${SCHEMA_DIR}" \
  --schema_path="$PACKAGES_DIR"/standard_library \
  --csharp_out="${OUT_DIR}" \
  --load_all_schema_on_schema_path \
  "${SCHEMA_DIR}"/*.schema \
  "${PACKAGES_DIR}"/standard_library/improbable/*.schema

# Generate a schema descriptor from the schemas:
"${PACKAGES_DIR}"/schema_compiler/schema_compiler \
  --schema_path="${SCHEMA_DIR}" \
  --schema_path="${PACKAGES_DIR}"/standard_library \
  --descriptor_set_out="${SCHEMA_BIN_DIR}"/schema.descriptor \
  --load_all_schema_on_schema_path \
  "${SCHEMA_DIR}"/*.schema \
  "${PACKAGES_DIR}"/standard_library/improbable/*.schema

popd