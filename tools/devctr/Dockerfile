# FROM ubuntu:latest
FROM ubuntu:20.04

ARG AT_SRC_DIR="/amatus"
ARG TINI_VERSION_TAG="v0.18.0"
ARG TMP_BUILD_DIR=/tmp/build

ARG RUST_TOOLCHAIN="1.52.1"
ARG AMATUS_SRC_DIR="/amatus"
ARG AMATUS_BUILD_DIR="$AMATUS_SRC_DIR/build"
ARG CARGO_REGISTRY_DIR="$AMATUS_BUILD_DIR/cargo_registry"
ARG CARGO_GIT_REGISTRY_DIR="$AMATUS_BUILD_DIR/cargo_git_registry"


#ARG VC_SRC_DIR_BUILD_DIR="$VC_SRC_DIR_SRC_DIR/build"
ARG DEBIAN_FRONTEND=noninteractive

ENV CARGO_HOME=/usr/local/rust
ENV RUSTUP_HOME=/usr/local/rust
ENV PATH="$PATH:$CARGO_HOME/bin"

RUN apt-get update \
    && apt-get -y install --no-install-recommends \
        # binutils-dev \
        # # Needed in order to be able to compile `userfaultfd-sys`.
        # clang \
        # cmake \
        # build-essential \
        # zlib1g-dev \
        # libncurses5-dev \
        # libgdbm-dev  \
        # libnss3-dev \
        # libreadline-dev \
        # libffi-dev \
        # libsqlite3-dev \
        # wget \
        # libbz2-dev \
        # curl \
        # file \
        # g++ \
        # gcc \
        # gcc-aarch64-linux-gnu \
        # git \
        # iperf3 \
        # iproute2 \
        # jq \
        # libdw-dev \
        # libiberty-dev \
        # libssl-dev \
        # libcurl4-openssl-dev \
        # lsof \
        # make \
        # musl-tools \
        # net-tools \
        # openssh-client \
        # pkgconf \
        # python3 \
        # python3-pip \
        tmux \
	neovim

RUN apt-get -y install software-properties-common
RUN apt-add-repository ppa:fish-shell/release-3 
RUN apt update 
RUN apt -y install fish

# We need to install node and npm from source because of this issue with the
# ubuntu repository:
# https://bugs.launchpad.net/ubuntu/+source/nodejs/+bug/1794589
# RUN (curl -sL https://deb.nodesource.com/setup_17.x | bash) \
#     && apt-get install -y nodejs \
#     && npm install --global yarn \
#     && rm -rf /var/lib/apt/lists/*

# Install the Rust toolchain
#
# RUN mkdir "$TMP_BUILD_DIR" \
#     && curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain "$RUST_TOOLCHAIN" \
#         && rustup target add x86_64-unknown-linux-musl \
#         && rustup component add rustfmt \
#         && rustup component add clippy-preview \
#         && rustup install "stable" \
#         && cd "$TMP_BUILD_DIR" \
#             && cargo install cargo-kcov \
#             && cargo +"stable" install cargo-audit \
#             # Fix a version that does not require cargo edition 2021.
#             && cargo install --locked cargo-deny --version '^0.9.1' \
#             && cargo kcov --print-install-kcov-sh | sh \
#         && rm -rf "$CARGO_HOME/registry" \
#         && ln -s "$CARGO_REGISTRY_DIR" "$CARGO_HOME/registry" \
#         && rm -rf "$CARGO_HOME/git" \
#         && ln -s "$CARGO_GIT_REGISTRY_DIR" "$CARGO_HOME/git" \
#     && cd / \
#     && rm -rf "$TMP_BUILD_DIR"    

# Add the tini init binary.
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION_TAG}/tini-static-amd64 /sbin/tini
RUN chmod +x /sbin/tini

#ADD docker-startup-cmds.sh /home/mahesh/git/amatus/tools/devctr/docdocker-startup-cmds.sh

COPY /tools/devctr/entrypoint.sh /entrypoint.sh

RUN chmod +x entrypoint.sh

WORKDIR "$AT_SRC_DIR"
ENTRYPOINT ["/entrypoint.sh"]
