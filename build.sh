#!/usr/bin/env bash

set -e -x

cd "$(dirname "$0")"

WORKER_DIRS=(HelloWorker OtherWorkers/DiceWorker OtherWorkers/Interactive/client)
BUILD_PLATFORMS=(macOS64 Windows64 Linux64)
PACKAGES_DIR="$(pwd)/packages"
BUILD_DIR="$(pwd)"
SDK_VERSION="13.5.1"
mkdir -p "${PACKAGES_DIR}"

function isLinux() {
  [[ "$(uname -s)" == "Linux" ]]
}

function isMacOS() {
  [[ "$(uname -s)" == "Darwin" ]]
}

function isWindows() {
  ! (isLinux || isMacOS)
}

# Return the target platform used by worker package names built for this OS.
function getPlatformName() {
  if isLinux; then
    echo "linux"
  elif isMacOS; then
    echo "macos"
  elif isWindows; then
    echo "win32"
  else
    echo "ERROR: Unknown platform." >&2
    exit 1
  fi
}
PLATFORM_NAME=$(getPlatformName)
BUILD_TOOL="msbuild"
if isWindows; then
  BUILD_TOOL="MSBuild.exe"
fi

retrievePackage() {
  TYPE=$1
  PACKAGE=$2
  TARGETDIR=$3

  pushd "${PACKAGES_DIR}"
  if [ ! -d "${TARGETDIR}" ]; then
    spatial package get --force --unzip "${TYPE}" "${PACKAGE}" "${SDK_VERSION}" "${TARGETDIR}"
  fi
  popd
}

# Get the tools:
# * Spatial Schema compiler
# * Standard Library Schemas
# * C# SDK
# * Core SDK for all platforms to enable building workers for MacOS, Windows or Linux
retrievePackage "tools" "schema_compiler-x86_64-${PLATFORM_NAME}" "schema_compiler"
retrievePackage "schema" "standard_library" "standard_library"
retrievePackage "worker_sdk" "csharp" "lib/csharp"
retrievePackage "worker_sdk" "core-dynamic-x86_64-win32" "lib/win64"
retrievePackage "worker_sdk" "core-dynamic-x86_64-linux" "lib/linux64"
retrievePackage "worker_sdk" "core-dynamic-x86_64-macos" "lib/macos64"

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
