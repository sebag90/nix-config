{ pkgs, goosebutils, system }:
with pkgs; [
  goosebutils
  goosebutils.packages.${system}.search
  goosebutils.packages.${system}.dstroy
  goosebutils.packages.${system}.devenver

  # cli tools
  wget
  curl
  bat
  lsd
  unzip
  serpl
  glow
  usbutils
  btop
  ctop
  ouch
  ripgrep
  gdu
  stow
  zellij
  zsh
  fish
  yazi
  delta

  # editor & lsps
  python313Packages.python-lsp-server
  python313Packages.jedi-language-server
  just-lsp
  texlab
  dockerfile-language-server
  docker-compose-language-service
  gopls
  nil
  yaml-language-server
  fish-lsp
  systemd-lsp
  marksman

  # programming tools
  podman
  docker-compose
  devpod
  podlet
  dive
  git
  lazygit
  just
  uv
  ty
  pyrefly
  cookiecutter
  prek
  pre-commit
  ruff
  python313Packages.ipython
  nodejs
]
