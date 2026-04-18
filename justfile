build:
    podman build -t "devenv:$(date +%d.%m.%Y)_$(uname -m)" -f devenv.containerfile .
