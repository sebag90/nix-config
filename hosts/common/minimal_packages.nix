# minimal packages, installed in all system including headless
{ pkgs, helix, goosebutils, ghostty, ... }:
{
  # nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    # goosebutils binaries
    goosebutils.packages.${pkgs.system}.search
    goosebutils.packages.${pkgs.system}.dstroy
    goosebutils.packages.${pkgs.system}.devenver

    # utils
    wget
    curl
    git
    bat
    eza
    unzip
    serpl
    usbutils
    btop
    ctop
    ouch
    gdu
    stow

    # programming
    devpod
    lazygit
    just
    uv
    ty
    pyrefly
    cookiecutter
    zellij
    yazi
    yaziPlugins.git
    pre-commit
    ruff
    # pipx
    # python313
    # python313Packages.pip
    python313Packages.ipython
    lazydocker

    # ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default
    # editors
    # helix
    helix.packages.${pkgs.stdenv.hostPlatform.system}.default
    # python313Packages.python-lsp-server
    # python313Packages.jedi-language-server
    dockerfile-language-server
    gopls
  ];
}
