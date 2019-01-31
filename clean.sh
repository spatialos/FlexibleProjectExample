#!/usr/bin/env bash

set -e -x

cd "$(dirname "$0")"

WORKER_DIRS=(HelloWorker OtherWorkers/DiceWorker OtherWorkers/Interactive/client)
BUILD_DIR="$(pwd)"

for WORKER in "${WORKER_DIRS[@]}"; do
  pushd "${BUILD_DIR}/${WORKER}/src"
  ./clean.sh
  popd
done

PACKAGES_DIR="$(pwd)/packages"
rm -rf "${PACKAGES_DIR}"
rm -rf SpatialOS/schema/bin
