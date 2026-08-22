build_nix_base:
    podman build -t devenv-nix-base:latest -f devenv-nix-base.containerfile .

# use the locally built base: just build NIX_BASE=devenv-nix-base:latest
build NIX_BASE="ghcr.io/sebag90/devenv-nix-base:latest":
    podman build --build-arg NIX_BASE={{NIX_BASE}} -t "devenv:$(date +%d.%m.%Y)_$(uname -m)" -f devenv.containerfile .

build_distro:
    podman build -t ghcr.io/sebag90/sebos:latest -f distro.containerfile .
