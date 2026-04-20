#!/bin/bash
set -euo pipefail

if [[ "$(uname)" == "Linux" ]]; then
  dnf install -y boost-devel ninja-build
else
  brew install boost ninja
fi

export NPROC
if [[ "$(uname)" == "Linux" ]]; then
  NPROC=$(nproc)
else
  NPROC=$(sysctl -n hw.ncpu)
fi

export SUDO=""
if [ "$(id -u)" != "0" ]; then
  SUDO="sudo"
fi

# release or dev
# build-release or build
cmake --preset dev
cmake --build --preset dev -j$NPROC
$SUDO cmake --install build
