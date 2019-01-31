#!/usr/bin/env bash

set -e -x

BUILD_PLATFORMS=(macOS64 Windows64 Linux64)
BUILD_TOOL="msbuild"
if isWindows; then
  BUILD_TOOL="MSBuild.exe"
fi

echo "${BUILD_PLATFORMS}"
for PLATFORM in "${BUILD_PLATFORMS[@]}"; do
  ${BUILD_TOOL} CsharpWorker.sln /property:Configuration=Release /property:Platform="$PLATFORM"
  cp -r bin ..
  rm -rf bin
  rm -rf obj
done