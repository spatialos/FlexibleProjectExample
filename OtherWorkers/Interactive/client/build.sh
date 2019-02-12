#!/usr/bin/env bash

set -e -x

BUILD_PLATFORMS=(macOS64 Windows64 Linux64)

function isLinux() {
  [[ "$(uname -s)" == "Linux" ]]
}

function isMacOS() {
  [[ "$(uname -s)" == "Darwin" ]]
}

function isWindows() {
  ! (isLinux || isMacOS)
}

BUILD_TOOL="msbuild"
if isWindows; then
  BUILD_TOOL="MSBuild.exe"
fi

echo "${BUILD_PLATFORMS}"
for PLATFORM in "${BUILD_PLATFORMS[@]}"; do
  ${BUILD_TOOL} ./src/CsharpWorker.sln /property:Configuration=Release /property:Platform="$PLATFORM"
  cp -r ./src/bin .
  rm -rf ./src/bin
  rm -rf ./src/obj
done
