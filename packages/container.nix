{ pkgs }:

with pkgs; [
  # container tools
  podman podman-tui podlet dive lazydocker
  
  # programming languages
  nodejs go
]
