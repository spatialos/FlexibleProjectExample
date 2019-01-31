#!/usr/bin/env bash

set -e -x

cd "$(dirname "$0")"

WORKER_DIRS=(HelloWorker OtherWorkers/DiceWorker OtherWorkers/Interactive/client)
BUILD_DIR="$(pwd)"

for WORKER in "${WORKER_DIRS[@]}"; do
  pushd "${BUILD_DIR}/${WORKER}"
  rm -rf bin
  popd
done

./clean_dependencies.sh
./clean_codegen.sh
