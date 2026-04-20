#!/bin/bash
set -euo pipefail

export SUDO=""
if [ "$(id -u)" != "0" ]; then
  SUDO="sudo"
fi

if [[ "$(uname)" == "Linux" ]]; then
  $SUDO apt-get install -y libboost-program-options-dev
else
  brew install boost
fi

export NPROC
if [[ "$(uname)" == "Linux" ]]; then
  NPROC=$(nproc)
else
  NPROC=$(sysctl -n hw.ncpu)
fi

# release or dev
# build-release or build
cmake --preset dev
cmake --build --preset dev -j$NPROC
$SUDO cmake --install build
