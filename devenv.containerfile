ARG NIX_BASE=ghcr.io/sebag90/devenv-nix-base:latest

FROM docker.io/alpine/git:latest as config
WORKDIR /workspace
# busts the clone layer whenever dotfiles HEAD moves
ADD https://api.github.com/repos/sebag90/dotfiles/commits/main /tmp/dotfiles-head
RUN git clone --depth 1 https://github.com/sebag90/dotfiles.git

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
    XDG_CONFIG_HOME=$HOME_DIR/.config \
    VIRTUAL_ENV=$VENV_DIR \
    UV_PROJECT_ENVIRONMENT=$VENV_DIR \
    SHELL=/nix/profile/bin/fish \
    NPM_CONFIG_PREFIX=/usr/local \
    DEVENV=1

RUN mkdir -p $HOME_DIR/.local/share $HOME_DIR/.cache \
    && ln -s /nix/profile/bin/podman /usr/local/bin/docker \
    && echo "ALL ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/container \
    && chmod 440 /etc/sudoers.d/container

RUN dnf install -y git wl-clipboard openssh-clients which && dnf clean all

# install pi coding agent and aws cli
RUN npm install -g --ignore-scripts @earendil-works/pi-coding-agent \
    && pi install npm:pi-ponytail \
    && curl -fsSL https://awscli.amazonaws.com/v2/install.sh | bash

# any uid must be able to write to the home dir (podman --user)
RUN uv venv $VENV_DIR \
    && chmod -R 777 $HOME_DIR

WORKDIR $WORK_DIR
ENTRYPOINT ["fish"]
