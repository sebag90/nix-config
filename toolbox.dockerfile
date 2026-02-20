FROM  ghcr.io/sebag90/devenv:latest as builder
FROM registry.fedoraproject.org/fedora-toolbox:43 as runner

# copy nix files
COPY --from=builder /nix /nix
COPY --from=builder /nix-profile /nix-profile

ENV PATH=/nix-profile/bin:$PATH

RUN ln -s /nix-profile/bin/fish /usr/bin/fish
