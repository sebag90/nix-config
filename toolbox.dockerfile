FROM ghcr.io/sebag90/devenv:0.3.0 as builder
FROM registry.fedoraproject.org/fedora-toolbox:43 as runner

# copy nix files
COPY --from=builder /nix /nix

ENV PATH=/nix/profile/bin:$PATH
