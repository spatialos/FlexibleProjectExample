#!/usr/bin/env bash

set -e -x

cd "$(dirname "$0")"

WORKER_DIRS=(HelloWorker OtherWorkers/DiceWorker OtherWorkers/Interactive/client)
BUILD_PLATFORMS=(macOS64 Windows64 Linux64)
PACKAGES_DIR="$(pwd)/packages"
BUILD_DIR="$(pwd)"
SDK_VERSION="13.5.1"

./download_dependencies.sh

./codegen.sh

# For each worker:
for WORKER in "${WORKER_DIRS[@]}"; do
  pushd "${BUILD_DIR}/${WORKER}"/src
  # Compile UserCode + GeneratedC# + CoreSDK + C#SDK into a binary
  ./build.sh
  popd
done

echo "Build complete"
