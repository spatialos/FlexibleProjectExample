#!/usr/bin/env bash

set -e -x

cd "$(dirname "$0")"

WORKER_DIRS=(HelloWorker OtherWorkers/DiceWorker OtherWorkers/Interactive/client)
BUILD_PLATFORMS=(macOS64 Windows64 Linux64)
DOWNLOAD_DIR="$(pwd)/packages"
BUILD_DIR="$(pwd)"
SDK_VERSION="13.5.1"
mkdir -p "${DOWNLOAD_DIR}"

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

  pushd "${DOWNLOAD_DIR}"
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
mkdir -p "${DOWNLOAD_DIR}"/csharp
"${DOWNLOAD_DIR}"/schema_compiler/schema_compiler \
  --schema_path="${BUILD_DIR}"/SpatialOS/schema \
  --schema_path="$DOWNLOAD_DIR"/standard_library \
  --csharp_out="${DOWNLOAD_DIR}"/csharp \
  --load_all_schema_on_schema_path \
  "${BUILD_DIR}"/SpatialOS/schema/*.schema \
  "${DOWNLOAD_DIR}"/standard_library/improbable/*.schema

# For each worker:
for WORKER in "${WORKER_DIRS[@]}"; do
  pushd "${BUILD_DIR}/${WORKER}"/src
  # Compile UserCode + GeneratedC# + CoreSDK + C#SDK into a binary
  mkdir -p improbable/generated
  mkdir -p improbable/dependencies/managed
  mkdir -p improbable/dependencies/native
  cp -R "${DOWNLOAD_DIR}"/csharp/* improbable/generated
  cp "${DOWNLOAD_DIR}"/lib/csharp/* improbable/dependencies/managed
  cp "${DOWNLOAD_DIR}"/lib/win64/* improbable/dependencies/native
  cp "${DOWNLOAD_DIR}"/lib/linux64/* improbable/dependencies/native
  cp "${DOWNLOAD_DIR}"/lib/macos64/* improbable/dependencies/native

  for PLATFORM in "${BUILD_PLATFORMS[@]}"; do
    ${BUILD_TOOL} CsharpWorker.sln /property:Configuration=Release /property:Platform="$PLATFORM"
    cp -r bin ..
    rm -rf bin
    rm -rf obj
  done
  popd
done

# Generate a schema descriptor from the schemas:
mkdir -p "${BUILD_DIR}"/SpatialOS/schema/bin
"${DOWNLOAD_DIR}"/schema_compiler/schema_compiler \
  --schema_path="${BUILD_DIR}"/SpatialOS/schema \
  --schema_path="${DOWNLOAD_DIR}"/standard_library \
  --load_all_schema_on_schema_path \
  --descriptor_set_out="${BUILD_DIR}"/SpatialOS/schema/bin/schema.descriptor \
  "${DOWNLOAD_DIR}"/standard_library/improbable/*.schema \
  "${BUILD_DIR}"/SpatialOS/schema/*.schema

echo "Build complete"
