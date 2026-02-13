{ config, pkgs, ... }:

{
  home.username = "root"; # or your remote user
  home.homeDirectory = "/root";

  programs.zsh.enable = true;
  programs.git.enable = true;

  imports = [
    ../common/dotfiles.nix
    ../common/minimal_packages.nix
    ../common/modules
  ];

  home.stateVersion = "24.05"; # or whichever matches your setup
}
