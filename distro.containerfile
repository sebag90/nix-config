FROM ghcr.io/sebag90/devenv:latest as nix
FROM quay.io/fedora-ostree-desktops/silverblue:44

RUN --mount=type=tmpfs,dst=/tmp \
	wget --no-hsts $(curl -s https://api.github.com/repos/cormullion/juliamono/releases/latest | \
		jq -r '.assets[] | select(.name == "JuliaMono-ttf.tar.gz") | .browser_download_url')  -O /tmp/JuliaMono.tar.gz \
	&& mkdir -p /usr/share/fonts/JuliaMono \
	&& tar -xzf /tmp/JuliaMono.tar.gz -C /usr/share/fonts/JuliaMono/ \
    && fc-cache -fv

RUN dnf -y copr enable scottames/ghostty && dnf -y install ghostty
COPY --from=nix /nix /nix
RUN ["bootc", "container", "lint"]
