#!/usr/bin/env bash

set -e -x

cd "$(dirname "$0")"

WORKER_DIRS=(HelloWorker OtherWorkers/DiceWorker OtherWorkers/Interactive/client)
BUILD_DIR="$(pwd)"
PACKAGES_DIR="$(pwd)/packages"
SDK_VERSION="13.5.1"

./download_dependencies.sh "${PACKAGES_DIR}" "${SDK_VERSION}"

./codegen.sh "${BUILD_DIR}" "${PACKAGES_DIR}"

# For each worker:
for WORKER in "${WORKER_DIRS[@]}"; do
  pushd "${BUILD_DIR}/${WORKER}"/src
  # Compile UserCode + GeneratedC# + CoreSDK + C#SDK into a binary
  ./build.sh
  popd
done

echo "Build complete"
