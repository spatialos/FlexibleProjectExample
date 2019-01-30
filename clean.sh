#!/usr/bin/env bash

set -e -x

cd "$(dirname "$0")"

WORKER_DIRS=(HelloWorker OtherWorkers/DiceWorker OtherWorkers/Interactive/client)
BUILD_DIR="$(pwd)"
PACKAGES_DIR="$(pwd)/packages"

for WORKER in "${WORKER_DIRS[@]}"; do
  pushd "${BUILD_DIR}/${WORKER}"
  rm -rf bin
  popd
done

rm -rf "${PACKAGES_DIR}"
rm -rf SpatialOS/schema/bin
