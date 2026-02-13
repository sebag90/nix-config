{ pkgs, ... }:
{
  home.packages = with pkgs; [
    firefox
    thunderbird
    ghostty  #.packages.${pkgs.stdenv.hostPlatform.system}.default

    # rust
    cargo
    rustfmt

    # clipboard
    wl-clipboard
    rclone
    gcc
    docker-compose
    deja-dup
    soundconverter
    ffmpeg
    home-manager
    pinta
    eartag
    impression

    # libreoffice
    # libreoffice-qt
    # hunspell
    # hunspellDicts.it_IT
    # hunspellDicts.en_US
    # hunspellDicts.de_DE
  ];
}
