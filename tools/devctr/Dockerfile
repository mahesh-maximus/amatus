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
	 binutils-dev \
         build-essential \
         wget \
         curl \
         git \
         python3 \
       	 python3-pip \
       	 tmux \
	 neovim \
	 fzf 

RUN apt-get -y install software-properties-common
RUN apt-add-repository ppa:fish-shell/release-3 
RUN apt update 
RUN apt -y install fish

# We need to install node and npm from source because of this issue with the
# ubuntu repository:
# https://bugs.launchpad.net/ubuntu/+source/nodejs/+bug/1794589
 RUN (curl -sL https://deb.nodesource.com/setup_17.x | bash) \
     && apt-get install -y nodejs \
     && npm install --global yarn \
     && rm -rf /var/lib/apt/lists/*

# Install the Rust toolchain

 RUN mkdir "$TMP_BUILD_DIR" \
     && curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain "$RUST_TOOLCHAIN" \
         && rustup target add x86_64-unknown-linux-musl \
         && rustup install "stable" \
         && cd "$TMP_BUILD_DIR" \
         && rm -rf "$CARGO_HOME/registry" \
         && ln -s "$CARGO_REGISTRY_DIR" "$CARGO_HOME/registry" \
         && rm -rf "$CARGO_HOME/git" \
         && ln -s "$CARGO_GIT_REGISTRY_DIR" "$CARGO_HOME/git" \
     && cd / \
     && rm -rf "$TMP_BUILD_DIR"    

# Add the tini init binary.
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION_TAG}/tini-static-amd64 /sbin/tini
RUN chmod +x /sbin/tini

RUN mkdir $HOME/.config
RUN mkdir $HOME/.config/nvim

RUN sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

COPY /tools/devctr/init.vim /init.vim
RUN cp /init.vim $HOME/.config/nvim/init.vim

RUN nvim --headless +PlugInstall +qall

COPY /tools/devctr/docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod +x docker-entrypoint.sh

WORKDIR "$AT_SRC_DIR"

ENTRYPOINT ["/sbin/tini", "--", "/docker-entrypoint.sh"]

