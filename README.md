# Steps

## Activate flake and nix command
Add the following line to `/etc/nix/nix.conf`
```
experimental-features = nix-command flakes
```

## Headless and laptop install
**ON FEDORA**: first activate daemon: `sudo systemctl enable --now nix-daemon` and add the user to the nix group: `nix-users`


* cd into `cd dotfiles/nix/`
* run `$ nix profile install .#headless`
* update with `$ nix profile upgrade headless`

# Post Install

## Podman
On non nixos machines:
* Checked the status of podman-restart.service: `$ systemctl status podman-restart.service`
* Enable service: `$ systemctl enable podman-restart.service`
* Enable for rootless: `$ systemctl --user enable podman-restart.service`
* Enable lingering `$ sudo loginctl enable-linger $USER`

On nixos:
```
systemctl --user enable podman-restart.service
loginctl enable-linger $USER
```

## Solaar (Logitech)
* create plugdev group: `$ sudo groupadd plugdev`
* add current user: `$ sudo gpasswd -a seba plugdev`
* reload rules: `$ sudo udevadm control --reload-rules && sudo udevadm trigger`

Solaar should now work for non sudo user

# Building containers
ARG AGGREGATOR_IMAGE=alpine

FROM ${AGGREGATOR_IMAGE} AS aggregator


build all: docker build -t myimage .

only final:
docker build \
  --build-arg AGGREGATOR_IMAGE=ghcr.io/yourname/nix-aggregator:2026-02 \
  -t myimage .

## creating manifest

* create a manifest: `$ podman manifest create <name>:<tag>`
* add images to manifest `$ podman manifest add <name>:<tag> <image_to_add>`
* push `$ podman manifest push --all <name>:<tag>`


## copy to host
Copy /nix from the container to the host
`docker run --rm --entrypoint=tar ghcr.io/sebag90/devenv -C / -cf - nix | sudo tar -C / -xf -`

## Run as working environment:
`podman run -it --rm --userns=keep-id --user $(id -u):$(id -g) -v $(pwd):/workspace:Z -w /workspace ghcr.io/sebag90/devenv:latest`

with podman:
`podman run -it --rm --userns=keep-id --user $(id -u):$(id -g) -v $(pwd):/workspace:Z -w /workspace -v $XDG_RUNTIME_DIR/podman/podman.sock:/run/podman/podman.sock -e CONTAINER_HOST=unix:///run/podman/podman.sock --security-opt label=disable ghcr.io/sebag90/devenv:latest`
