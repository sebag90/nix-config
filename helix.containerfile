# syntax=docker/dockerfile:1

FROM rust:1.90-bookworm AS builder

ARG HELIX_REPO=https://github.com/helix-editor/helix.git
ARG HELIX_REF=master

# Build dependencies:
# - git: clone Helix and fetch tree-sitter grammars
# - gcc/g++: required for tree-sitter grammar compilation
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        git \
        gcc \
        g++ \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src

RUN git clone --depth 1 --branch "${HELIX_REF}" "${HELIX_REPO}" helix

WORKDIR /src/helix

# Build/install hx and the tree-sitter grammars.
RUN cargo install \
        --path helix-term \
        --locked \
        --root /opt/helix

# Put Helix's runtime alongside the binary.
RUN mkdir -p /opt/helix/share \
    && cp -a runtime /opt/helix/share/runtime


# ------------------------------------------------------------
# Runtime image
# ------------------------------------------------------------
FROM debian:bookworm-slim

ARG UID=1000
ARG GID=1000

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        git \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd --gid "${GID}" helix \
    && useradd --uid "${UID}" --gid "${GID}" \
        --create-home \
        --shell /bin/bash \
        helix

COPY --from=builder /opt/helix/bin/hx /usr/local/bin/hx
COPY --from=builder /opt/helix/share/runtime /usr/local/share/helix/runtime

ENV HELIX_RUNTIME=/usr/local/share/helix/runtime

USER helix
WORKDIR /workspace

ENTRYPOINT ["hx"]
