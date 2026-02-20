FROM nixos/nix AS builder

RUN mkdir -p /etc/nix
COPY <<EOF /etc/nix/nix.conf
sandbox = false
filter-syscalls = false
experimental-features = nix-command flakes
EOF

WORKDIR /build-dir
COPY . .

COPY <<'EOF' /build-dir/build_container.sh
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
 && cp -r /root/.nix-profile /out/.nix-profile

FROM alpine AS runner

# copy nix files
COPY --from=builder /out/nix /nix
COPY --from=builder /out/.nix-profile /nix-profile

ENV PATH=/nix-profile/bin:$PATH \
    LANG=C.UTF-8

WORKDIR /dotfiles
RUN git clone https://github.com/sebag90/dotfiles.git
WORKDIR /dotfiles/dotfiles
RUN mkdir -p $HOME/.config
RUN stow -t $HOME/.config config

WORKDIR /workspace
ENTRYPOINT ["fish"]
