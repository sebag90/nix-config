build:
    podman build -t "devenv:$(date +%d.%m.%Y)_$(uname -m)" -f devenv.containerfile .

build_distro:
    podman build -t ghcr.io/sebag90/sebos:latest -f distro.containerfile .
