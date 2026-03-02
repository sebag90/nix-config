# minimal packages, installed in all system including headless
{ pkgs, helix, goosebutils, ghostty, ... }:
{
  # nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    # helix
    helix.packages.${pkgs.stdenv.hostPlatform.system}.default
    python313Packages.python-lsp-server
    python313Packages.jedi-language-server
    dockerfile-language-server
    gopls
  ];
}
