#!/usr/bin/env bash

set -e -x

cd "$(dirname "$0")"

echo $(pwd)

WORKER_DIRS=(HelloWorker DiceWorker client)
SDK_VERSION="13.5.1"
BUILD_DIR="$(pwd)/../.."
TOOLS_DIR="${BUILD_DIR}/SpatialOS/tools/${SDK_VERSION}"

./download_dependencies.sh "${SDK_VERSION}"

./generate-schema-descriptor.sh "${BUILD_DIR}" "${TOOLS_DIR}"

# For each worker:
for WORKER in "${WORKER_DIRS[@]}"; do
  pushd "${BUILD_DIR}/${WORKER}"
  # Compile UserCode + GeneratedC# + CoreSDK + C#SDK into a binary
  ./build.sh
  popd
done

echo "Build complete"
