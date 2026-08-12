FROM debian:trixie-slim

RUN \
dpkg --add-architecture armel && \
apt-get update && \
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  crossbuild-essential-armel \
  qt6-base-dev:armel \
  qt6-declarative-dev:armel \
  qt6-svg-dev:armel \
  qt6-websockets-dev:armel \
  qt6-base-dev-tools \
  zlib1g-dev:armel \
  clang \
  make \
  cmake \
  file \
  git \
  ca-certificates && \
rm -rf /var/lib/apt/lists/*

COPY cmake/pocketbook.toolchain.cmake /opt/pocketbook/toolchain.cmake
ENV CMAKE_TOOLCHAIN_FILE=/opt/pocketbook/toolchain.cmake

WORKDIR /workspace
CMD ["/bin/bash"]
