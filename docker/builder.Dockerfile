# Usage(on repo root folder):
#   docker build . -t librewolf-source-installer:builder -f ./docker/builder.Dockerfile
# Optionally, add arguments like: --build-arg UBUNTU_VER=latest

# Arguments configuration
ARG UBUNTU_VER=jammy
ARG RUST_VER=stable

# Environment setup
FROM ubuntu:${UBUNTU_VER} as builder

## Arguments import
ARG RUST_VER

## Set deb to non-interactive mode and upgrade packages
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && export DEBIAN_FRONTEND=noninteractive 
RUN apt -y update && apt -y upgrade

## Install system dependencies
RUN apt install -y sudo make wget git gpg xz-utils unzip pkg-config libasound2-dev libpulse-dev m4 \
    gcc-multilib clang libclang-dev lld llvm python3-pip nodejs libpango1.0-dev nasm \
    libx11-xcb-dev libxrandr-dev libxcomposite-dev libxcursor-dev libxdamage-dev libxfixes-dev libxi-dev

## Rust installation
RUN wget -O install-rustup.sh https://sh.rustup.rs && \
    sh install-rustup.sh -yq --default-toolchain none && \
    rm install-rustup.sh
ENV PATH "${PATH}:/root/.cargo/bin/"
RUN rustup default ${RUST_VER}
RUN cargo install cbindgen

## Create and set WORKDIR to mount in docker build
RUN mkdir /repo
WORKDIR /repo
