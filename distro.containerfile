ARG HELIX_IMAGE=ghcr.io/sebag90/helix:latest
ARG DEVENV_IMAGE=ghcr.io/sebag90/devenv:latest

FROM ${HELIX_IMAGE} as helix
FROM quay.io/fedora-ostree-desktops/silverblue:44

RUN --mount=type=tmpfs,dst=/tmp \
	wget --no-hsts $(curl -s https://api.github.com/repos/cormullion/juliamono/releases/latest | \
		jq -r '.assets[] | select(.name == "JuliaMono-ttf.tar.gz") | .browser_download_url')  -O /tmp/JuliaMono.tar.gz \
	&& mkdir -p /usr/share/fonts/JuliaMono \
	&& tar -xzf /tmp/JuliaMono.tar.gz -C /usr/share/fonts/JuliaMono/ \
    && fc-cache -fv

RUN dnf install -y lsd fish \
	&& dnf clean all

COPY --from=helix /usr/local/bin/hx /usr/local/bin/hx
COPY --from=helix /usr/local/share/helix /usr/local/share/helix

ENV HELIX_RUNTIME=/usr/local/share/helix/runtime
RUN ["bootc", "container", "lint"]
