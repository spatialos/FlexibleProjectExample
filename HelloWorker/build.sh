#!/usr/bin/env bash

set -e -x

BUILD_PLATFORMS=(macOS64 Windows64 Linux64)
BUILD_TOOL="msbuild"

echo "${BUILD_PLATFORMS}"
for PLATFORM in "${BUILD_PLATFORMS[@]}"; do
  ${BUILD_TOOL} ./src/CsharpWorker.sln /property:Configuration=Release /property:Platform="$PLATFORM"
  cp -r ./src/bin .
  rm -rf ./src/bin
  rm -rf ./src/obj
done