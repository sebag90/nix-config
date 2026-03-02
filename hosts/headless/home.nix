{ config, pkgs, ... }:

{
  home.username = "seba"; # or your remote user
  home.homeDirectory = "/home/seba";

  programs.zsh.enable = true;
  programs.git.enable = true;

  imports = [
    ../common/modules
    ../common/cli_tools.nix
    ../common/editor.nix
    ../common/programming_tools.nix
    ../common/containers.nix
    ../common/programming_languages.nix
  ];

  home.stateVersion = "24.05"; # or whichever matches your setup
}
