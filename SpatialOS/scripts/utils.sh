#!/usr/bin/env bash

# This script defines various paths and methods to be used when building the project

set -e -x
pushd "$( dirname "${BASH_SOURCE[0]}" )"

SDK_VERSION="14.0.0"

WORKER_DIRS=("$(pwd)/../../HelloWorker" "$(pwd)/../../DiceWorker" "$(pwd)/../../client")
TOOLS_DIR="$(pwd)/../tools/${SDK_VERSION}"
LIB_DIR="$(pwd)/../lib/${SDK_VERSION}"
SCHEMA_DIR="$(pwd)/../schema"
SCHEMA_BIN_DIR="${SCHEMA_DIR}/bin"
SNAPSHOTS_DIR="$(pwd)/../snapshots"

# Returns platform name of this machine
function getPlatformName() {
  if [[ "$(uname -s)" == "Linux" ]]; then
    echo "linux"
  elif [[ "$(uname -s)" == "Darwin" ]]; then
    echo "macos"
  else
    echo "win32"
  fi
}

PLATFORM_NAME=$(getPlatformName)
BUILD_TOOL="msbuild"
if [[ "${PLATFORM_NAME}" == "win32" ]]; then
  BUILD_TOOL="MSBuild.exe"
fi

BUILD_PLATFORMS=(Windows64 macOS64 Linux64)

popd