# common packages installed in all systems (except for headless)
{ pkgs, ... }:
{
  # nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    # containers
    podman
    podman-tui
    podlet
    dive
    lazydocker
  ];
}
