#!/usr/bin/env bash

# This script retrieves the project dependencies from the SpatialOS SDK

set -e -x
pushd "$( dirname "${BASH_SOURCE[0]}" )"
source ./utils.sh

retrievePackage() {
  TYPE=$1
  PACKAGE=$2
  TARGETDIR=$3
  if [ ! -d "${TARGETDIR}" ]; then
    spatial package get --force --unzip "${TYPE}" "${PACKAGE}" "${SDK_VERSION}" "${TARGETDIR}"
  fi
}

# Download and unzip the project dependencies from the SpatialOS SDK:
# * Schema compiler (tools folder)
# * C# SDK (lib folder)
# * Core SDK for Windows, MacOs and Linux (lib folder)
# * Standard schema library (schema/improbable folder)

mkdir -p "${TOOLS_DIR}"
pushd "${TOOLS_DIR}"
retrievePackage "tools" "schema_compiler-x86_64-${PLATFORM_NAME}" "schema_compiler"
popd

mkdir -p "${LIB_DIR}"
pushd "${LIB_DIR}"
retrievePackage "worker_sdk" "csharp" "csharp"
retrievePackage "worker_sdk" "core-dynamic-x86_64-win32" "win64"
retrievePackage "worker_sdk" "core-dynamic-x86_64-macos" "macos64"
retrievePackage "worker_sdk" "core-dynamic-x86_64-linux" "linux64"

# Move the Worker SDK libraries into the lib folder of each worker project
for WORKER_DIR in "${WORKER_DIRS[@]}"; do
  mkdir -p "${WORKER_DIR}/lib/improbable/sdk/${SDK_VERSION}"
  cp -r "${LIB_DIR}" "${WORKER_DIR}/lib/improbable/sdk"
done
popd

pushd "${SCHEMA_DIR}"
retrievePackage "schema" "standard_library" ""
popd

popd