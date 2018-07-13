#!/usr/bin/env bash

set -e -x

cd "$(dirname "$0")"

WORKER_DIRS=(HelloWorker OtherWorkers/DiceWorker OtherWorkers/Interactive/client)
BUILD_DIR="$(pwd)"
DOWNLOAD_DIR="$(pwd)/build"

for WORKER in "${WORKER_DIRS[@]}"; do
  pushd "${BUILD_DIR}/${WORKER}"
  rm -rf src/improbable
  rm -rf bin
  popd
done

rm -rf "${DOWNLOAD_DIR}"
rm -rf SpatialOS/schema/bin
