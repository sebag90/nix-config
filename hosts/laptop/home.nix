{ config, pkgs, ... }:

{
  home.username = "seba"; # or your remote user
  home.homeDirectory = "/home/seba";

  programs.git.enable = true;

  imports = [
    ../common/dotfiles.nix
    ../common/minimal_packages.nix
    ../common/packages.nix
    ../common/modules
    ./packages.nix
  ];

  home.stateVersion = "24.11"; # or whichever matches your setup
}
