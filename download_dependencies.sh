#!/usr/bin/env bash

set -e -x

cd "$(dirname "$0")"

PACKAGES_DIR="$1"
SDK_VERSION="$2"
mkdir -p "${PACKAGES_DIR}"

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
retrievePackage "worker_sdk" "csharp" "lib/csharp"
retrievePackage "worker_sdk" "core-dynamic-x86_64-win32" "lib/win64"
retrievePackage "worker_sdk" "core-dynamic-x86_64-linux" "lib/linux64"
retrievePackage "worker_sdk" "core-dynamic-x86_64-macos" "lib/macos64"
