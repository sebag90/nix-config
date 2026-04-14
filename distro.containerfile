FROM ghcr.io/sebag90/devenv:latest as nix
FROM quay.io/fedora-ostree-desktops/silverblue:43

RUN --mount=type=tmpfs,dst=/tmp \
	wget --no-hsts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/CascadiaCode.zip  -O /tmp/CascadiaCode.zip \
	&& unzip /tmp/CascadiaCode.zip -d /usr/share/fonts/CascadiaCode \
    && fc-cache -fv

RUN dnf -y copr enable scottames/ghostty && dnf -y install ghostty
COPY --from=nix /nix /nix
RUN ["bootc", "container", "lint"]
