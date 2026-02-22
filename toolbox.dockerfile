FROM  ghcr.io/sebag90/devenv:latest as builder
FROM registry.fedoraproject.org/fedora-toolbox:43 as runner

# copy nix files
COPY --from=builder /nix /nix

ENV PATH=/nix/profile/bin:$PATH
