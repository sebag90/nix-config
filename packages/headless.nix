{ pkgs, helix, goosebutils, system }:

with pkgs; [
  # goosebutils
  goosebutils.packages.${system}.search
  goosebutils.packages.${system}.dstroy
  goosebutils.packages.${system}.devenver

  # cli tools
  wget curl bat eza unzip serpl glow usbutils btop ctop ouch gdu stow zellij zsh fish

  # editor & lsps
  helix.packages.${system}.default
  python313Packages.python-lsp-server
  python313Packages.jedi-language-server
  dockerfile-language-server
  gopls

  # programming tools
  git devpod lazygit just uv ty pyrefly cookiecutter pre-commit ruff python313Packages.ipython
]
