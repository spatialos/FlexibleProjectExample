#!/usr/bin/env bash

set -e -x

cd "$(dirname "$0")"

SDK_VERSION="$1"
TOOLS_DIR="$(pwd)/../tools/${SDK_VERSION}"
mkdir -p "${TOOLS_DIR}"

retrievePackage() {
  TYPE=$1
  PACKAGE=$2
  TARGETDIR=$3

  pushd "${TOOLS_DIR}"
  if [ ! -d "${TARGETDIR}" ]; then
    spatial package get --force --unzip "${TYPE}" "${PACKAGE}" "${SDK_VERSION}" "${TARGETDIR}"
  fi
  popd
}

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

# Get the tools:
# * Spatial Schema compiler
# * Standard Library Schemas
# * C# SDK
# * Core SDK for all platforms to enable building workers for MacOS, Windows or Linux
retrievePackage "tools" "schema_compiler-x86_64-${PLATFORM_NAME}" "schema_compiler"
retrievePackage "schema" "standard_library" "standard_library"
retrievePackage "worker_sdk" "csharp" "lib/improbable/sdk/${SDK_VERSION}/csharp"
retrievePackage "worker_sdk" "core-dynamic-x86_64-win32" "lib/improbable/sdk/${SDK_VERSION}/win64"
retrievePackage "worker_sdk" "core-dynamic-x86_64-linux" "lib/improbable/sdk/${SDK_VERSION}/linux64"
retrievePackage "worker_sdk" "core-dynamic-x86_64-macos" "lib/improbable/sdk/${SDK_VERSION}/macos64"

WORKER_DIRS=(HelloWorker DiceWorker client)
BUILD_DIR="$(pwd)/../.."
moveLib() {
  # For each worker:
  for WORKER in "${WORKER_DIRS[@]}"; do
    cp -r "${TOOLS_DIR}/lib" "${BUILD_DIR}/${WORKER}"
  done
}

moveLib
rm -rf "${TOOLS_DIR}/lib"
