{ pkgs,... }:

{
  home = {
    username = "sebastiano";
    homeDirectory = "/Users/sebastiano";
    stateVersion = "25.05";
  };

  imports = [
    # ../common/dotfiles.nix
    ../common/packages.nix
    ../common/minimal_packages.nix
    ../common/modules
    ./packages.nix
  ];

  home.sessionVariables = {
    NIX_BUILD_EXEC = "darwin-rebuild";
  };
}
