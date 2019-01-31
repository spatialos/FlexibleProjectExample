#!/usr/bin/env bash

set -e -x

cd "$(dirname "$0")"

WORKER_DIRS=(HelloWorker OtherWorkers/DiceWorker OtherWorkers/Interactive/client)
BUILD_PLATFORMS=(macOS64 Windows64 Linux64)
PACKAGES_DIR="$(pwd)/packages"
BUILD_DIR="$(pwd)"
SDK_VERSION="13.5.1"

./download_dependencies.sh

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

BUILD_TOOL="msbuild"
if isWindows; then
  BUILD_TOOL="MSBuild.exe"
fi

# For each worker:
for WORKER in "${WORKER_DIRS[@]}"; do
  pushd "${BUILD_DIR}/${WORKER}"/src
  # Compile UserCode + GeneratedC# + CoreSDK + C#SDK into a binary
  for PLATFORM in "${BUILD_PLATFORMS[@]}"; do
    ${BUILD_TOOL} CsharpWorker.sln /property:Configuration=Release /property:Platform="$PLATFORM"
    cp -r bin ..
    rm -rf bin
    rm -rf obj
  done
  popd
done

# Generate a schema descriptor from the schemas:
"${PACKAGES_DIR}"/schema_compiler/schema_compiler \
  --schema_path="${SCHEMA_DIR}" \
  --schema_path="${PACKAGES_DIR}"/standard_library \
  --load_all_schema_on_schema_path \
  --descriptor_set_out="${SCHEMA_DIR}"/bin/schema.descriptor \
  "${PACKAGES_DIR}"/standard_library/improbable/*.schema \
  "${SCHEMA_DIR}"/*.schema

echo "Build complete"
