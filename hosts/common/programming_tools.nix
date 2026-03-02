# minimal packages, installed in all system including headless
{ pkgs, helix, goosebutils, ghostty, ... }:
{
  # nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    git
    devpod
    lazygit
    just
    uv
    ty
    pyrefly
    cookiecutter
    pre-commit
    ruff
    python313Packages.ipython
  ];
}
