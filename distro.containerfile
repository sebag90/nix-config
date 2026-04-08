FROM ghcr.io/sebag90/devenv:latest as nix
FROM quay.io/fedora-ostree-desktops/silverblue:43

RUN dnf -y copr enable scottames/ghostty && dnf -y install ghostty
COPY --from=nix /nix /nix

RUN ["bootc", "container", "lint"]
