# FROM docker.io/nixos/nix AS builder

# RUN mkdir -p /etc/nix
# COPY <<EOF /etc/nix/nix.conf
# sandbox = false
# filter-syscalls = false
# experimental-features = nix-command flakes
# EOF

# WORKDIR /build-dir
# COPY flake.nix .
# COPY packages packages

# COPY <<'EOF' /build-dir/build_container.sh
# ARCH=$(uname -m)
# OS=$(uname -s | tr '[:upper:]' '[:lower:]')
# SYSTEM="${ARCH}-${OS}"

# nix build \
#   --option sandbox false \
#   --option filter-syscalls false \
#   .#
# EOF

# RUN bash build_container.sh

# # remove conflicting packages
# RUN nix-env -e git-minimal
# RUN nix-env -e wget
# RUN nix-env -e man-db

# RUN nix-env -i ./result

# # clean installation
# RUN nix-store --gc
# RUN nix-collect-garbage -d

# # copy configs and bins
# # store
# RUN mkdir -p /out/nix/store \
#  && nix-store -qR ./result \
#  | xargs -I{} cp -r {} /out/nix/store

# # profiles
# RUN mkdir -p /out/nix/var/nix \
#  && cp -r /nix/var/nix/profiles /out/nix/var/nix/

# # home
# RUN mkdir -p /out/root \
#  && cp -r /root/.nix-profile /out/nix-profile

# FROM fedora AS aggregator
# # copy nix files
# COPY --from=builder /out/nix /nix
# COPY --from=builder /out/nix-profile /nix/profile
# # COPY --from=builder /out/config /nix/config

# # clean broken links
# RUN find /nix -xtype l -delete
FROM ghcr.io/sebag90/devenv:latest as aggregator
FROM docker.io/alpine/git:latest as config
WORKDIR /workspace
RUN git clone https://github.com/sebag90/dotfiles.git

FROM fedora AS final

ARG WORK_DIR=/workspace
ARG CONFIG_DIR=/usr/local/share/config

COPY --from=aggregator /nix /nix
COPY --from=config $WORK_DIR/dotfiles/config $CONFIG_DIR

ENV PATH=/nix/profile/bin:$PATH \
    LANG=C.UTF-8 \
    XDG_CONFIG_HOME=$CONFIG_DIR

RUN chmod -R 777 $CONFIG_DIR \
    && echo "ALL ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/container \
    && chmod 440 /etc/sudoers.d/container

WORKDIR $WORK_DIR
ENTRYPOINT ["fish"]
