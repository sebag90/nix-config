# Steps

## Activate flake and nix command
Add the following line to `/etc/nix/nix.conf`
```
experimental-features = nix-command flakes
```

## Headless and laptop install
**ON FEDORA**: first activate daemon: `sudo systemctl enable --now nix-daemon`


* cd into `cd dotfiles/nix/`
* run `$ nix run .#homeConfigurations.<system>.<headless | laptop>.activationPackage`

`<system>` ist the architecture (eg. x86_64-linux, check dockerfile for how to build automatically)

## NIX secret file
inside the directory of the host, create a `secrets.nix` (`dotfiles/nix/hosts/nixos/secrets.nix`):
```
{
  userEmail = "myemail@secrets.com";
}
```

and make sure to add the variable `DOTFILES_SECRETS` to your zsh config (`nixos/hosts/nixos/modules/zsh.nix`):
```
sessionVariables = {
  ZSH_CUSTOM = "${config.home.homeDirectory}/.config/zsh";
  NIX_BUILD_EXEC = "nixos-rebuild";
  DOTFILES_SECRETS = "${config.home.homeDirectory}/code/dotfiles/nixos/hosts/nixos/secrets.nix";
};
```

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

# SebOS
* install Fedora silverblue
* remove Firefox: rpm-ostree override remove firefox firefox-langpacks
* install Firefox from flathub (contains all codecs)
* run docker registry: `$ podman run -d -p 5000:5000 registry:2`
* build the image: `$ podman build -t localhost:5000/seboy:latest -f distro.containerfile .`
* push the image to local registry
* modify: /etc/containers/registries.conf:
  ```
  [[registry]]
  location = "localhost:5000"
  insecure = true
  ```
* sudo rpm-ostree rebase ostree-unverified-registry:localhost:5000/myimage:latest
