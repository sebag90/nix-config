{ pkgs,... }:

{
  home = {
    username = "seba";
    homeDirectory = "/home/seba";
    stateVersion = "25.05";
  };

  imports = [
    ../common/dotfiles.nix
    ../common/packages.nix
    ../common/cli_tools.nix
    ../common/editor.nix
    ../common/programming_tools.nix
    ../common/containers.nix
    ../common/programming_languages.nix
    ../common/containers.nix
    ../common/gui_tools.nix
    ../common/modules
    ./packages.nix
  ];

  home.sessionVariables = {
    NIX_BUILD_EXEC = "nixos-rebuild";
  };
}
