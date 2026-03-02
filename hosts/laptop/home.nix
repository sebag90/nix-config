{ config, pkgs, ... }:

{
  home.username = "seba"; # or your remote user
  home.homeDirectory = "/home/seba";

  programs.git.enable = true;

  imports = [
    ../common/cli_tools.nix
    ../common/editor.nix
    ../common/programming_tools.nix
    ../common/containers.nix
    ../common/programming_languages.nix
    ../common/gui_tools.nix
    ../common/modules
    ./packages.nix
  ];

  home.stateVersion = "24.11"; # or whichever matches your setup
}
