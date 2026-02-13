{pkgs, ...}: {
  # use zsh
  programs.zsh.enable = true;
  programs.zsh.ohMyZsh.enable = true;
  users.defaultUserShell = pkgs.fish;

  # fish
  programs.fish.enable = true;
}
