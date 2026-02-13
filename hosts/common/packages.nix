# common packages installed in all systems (except for headless)
{ pkgs, ... }:
{
  # nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    # utils
    glow
    btop
    imagemagick

    # programming
    meld
    nodejs
    go
    wezterm

    # editors
    vscodium
    # zed-editor
    # flow-control

    # containers
    podman
    podman-tui
    podlet
    dive
    devcontainer
  ];
}
