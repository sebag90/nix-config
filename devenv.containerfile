ARG NIX_BASE=ghcr.io/sebag90/devenv-nix-base:latest

FROM docker.io/alpine/git:latest as config
WORKDIR /workspace
RUN git clone https://github.com/sebag90/dotfiles.git

FROM ${NIX_BASE} AS nix_base

FROM fedora AS final

ARG WORK_DIR=/workspace
ARG HOME_DIR=/home/dev
ARG VENV_DIR=/home/dev/venv

COPY --from=nix_base /nix /nix
COPY --from=config /workspace/dotfiles/config $HOME_DIR/.config

ENV PATH=$VENV_DIR/bin:/nix/profile/bin:$PATH \
    LANG=C.UTF-8 \
    HOME=$HOME_DIR \
    VIRTUAL_ENV=$VENV_DIR \
    UV_PROJECT_ENVIRONMENT=$VENV_DIR \
    SHELL=/nix/profile/bin/fish \
    NPM_CONFIG_PREFIX=/usr/local \
    DEVENV=1

RUN mkdir -p $HOME_DIR/.local/share $HOME_DIR/.cache \
    && ln -s /nix/profile/bin/podman /usr/local/bin/docker \
    && echo "ALL ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/container \
    && chmod 440 /etc/sudoers.d/container

RUN dnf install -y git openssh-clients && dnf clean all

# install pi coding agent (bash, ca-certificates and ripgrep come from fedora + nix)
RUN npm install -g --ignore-scripts @earendil-works/pi-coding-agent \
    && pi install npm:pi-ponytail

# any uid must be able to write to the home dir (podman --user)
# keep this LAST: any RUN after it re-creates root-owned dirs under $HOME
RUN uv venv $VENV_DIR \
    && chmod -R 777 $HOME_DIR

WORKDIR $WORK_DIR
ENTRYPOINT ["fish"]
