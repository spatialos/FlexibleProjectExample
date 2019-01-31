#!/usr/bin/env bash

set -e -x

BUILD_DIR="$(pwd)"
PACKAGES_DIR="$(pwd)/packages"

# Generate C# code from the schemas:
SCHEMA_DIR="${BUILD_DIR}"/SpatialOS/schema
OUT_DIR="${SCHEMA_DIR}"/bin/generated/csharp

mkdir -p "${OUT_DIR}"
"${PACKAGES_DIR}"/schema_compiler/schema_compiler \
  --schema_path="${SCHEMA_DIR}" \
  --schema_path="$PACKAGES_DIR"/standard_library \
  --csharp_out="${OUT_DIR}" \
  --load_all_schema_on_schema_path \
  "${SCHEMA_DIR}"/*.schema \
  "${PACKAGES_DIR}"/standard_library/improbable/*.schema
