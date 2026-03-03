# minimal packages, installed in all system including headless
{ pkgs, helix, goosebutils, ghostty, ... }:
{
  # nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    # goosebutils binaries
    goosebutils.packages.${pkgs.system}.search
    goosebutils.packages.${pkgs.system}.dstroy
    goosebutils.packages.${pkgs.system}.devenver

    # web utils
    wget
    curl

    # file
    bat
    eza
    unzip
    serpl  # fizzy search
    glow  # markdown renderer

    # system
    usbutils
    btop
    ctop
    ouch
    gdu
    stow

    # productivity
    # yazi
    # yaziPlugins.git
    zellij
  ];
}
