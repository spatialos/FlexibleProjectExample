#!/usr/bin/env bash

# This script builds the Client worker executable to client/bin

set -e -x
pushd "$( dirname "${BASH_SOURCE[0]}" )"
source ../SpatialOS/scripts/utils.sh

# Download the dependenties in case they are not present
if [ ! -d "lib" ] || [ ! -d "${SCHEMA_DIR}/improbable" ]; then
  ../SpatialOS/scripts/download_dependencies.sh
fi

# Generate C# component API code from the project schema using the schema compiler
OUT_DIR="$(pwd)/src/improbable/generated"
rm -rf "${OUT_DIR}"
mkdir -p "${OUT_DIR}"
"${TOOLS_DIR}"/schema_compiler/schema_compiler \
  --schema_path="${SCHEMA_DIR}" \
  --csharp_out="${OUT_DIR}" \
  --load_all_schema_on_schema_path \
  "${SCHEMA_DIR}"/*.schema \
  "${SCHEMA_DIR}"/improbable/*.schema

# Build a worker executable for each target build platform
for PLATFORM in "${BUILD_PLATFORMS[@]}"; do
  ${BUILD_TOOL} $(pwd)/src/CsharpWorker.sln /property:Configuration=Release /property:Platform="$PLATFORM"
  cp -r $(pwd)/src/bin .
  rm -rf $(pwd)/src/bin
  rm -rf $(pwd)/src/obj
done

popd