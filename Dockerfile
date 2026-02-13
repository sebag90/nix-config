FROM nixos/nix AS builder

RUN mkdir -p /etc/nix
COPY <<EOF /etc/nix/nix.conf
sandbox = false
filter-syscalls = false
experimental-features = nix-command flakes
EOF

WORKDIR /build-dir
COPY . .

COPY <<'EOF' /build-dir/nix/build_container.sh
ARCH=$(uname -m)
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
SYSTEM="${ARCH}-${OS}"

nix build \
  --option sandbox false \
  --option filter-syscalls false \
  .#homeConfigurations.${SYSTEM}.container.activationPackage
EOF

RUN bash build_container.sh

# remove conflicting packages
RUN nix-env -e git-minimal
RUN nix-env -e wget
RUN nix-env -e man-db

RUN ./result/activate

# clean installation
RUN nix-store --gc
RUN nix-collect-garbage -d

# copy configs and bins
# store
RUN mkdir -p /out/nix/store \
 && nix-store -qR ./result \
 | xargs -I{} cp -r {} /out/nix/store

# profiles
RUN mkdir -p /out/nix/var/nix \
 && cp -r /nix/var/nix/profiles /out/nix/var/nix/

# home
RUN mkdir -p /out/root \
 && cp -r /root/.nix-profile /out/root/.nix-profile

# config
RUN mkdir -p /out/root \
 && cp -rL /root/.config /out/root/.config

FROM debian:trixie-slim AS runner
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    bash \
 && rm -rf /var/lib/apt/lists/*

# copy nix files
COPY --from=builder /out/nix /nix
COPY --from=builder /out/root /root
COPY --from=builder /out/root/.config /root/.config
COPY --from=builder /out/root/.nix-profile /root/.nix-profile

ENV HOME=/root \
    PATH=/root/.nix-profile/bin:/bin:/usr/bin \
    LANG=C.UTF-8

WORKDIR /workspace
ENTRYPOINT ["fish"]
