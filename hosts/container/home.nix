{ config, pkgs, ... }:

{
  home.username = "root"; # or your remote user
  home.homeDirectory = "/root";

  programs.zsh.enable = true;
  programs.git.enable = true;

  imports = [
    ../common/cli_tools.nix
    ../common/editor.nix
    ../common/programming_tools.nix
    ../common/modules
  ];

  home.stateVersion = "24.05"; # or whichever matches your setup
}
