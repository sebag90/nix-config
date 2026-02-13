{pkgs, ...}:
{
  fonts.packages = with pkgs; [
    nerd-fonts.symbols-only
    cascadia-code
    nerd-fonts.fira-code
  ];
}
