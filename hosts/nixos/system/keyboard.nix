{ pkgs, ...}:
{
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  # i18n.inputMethod = {
  #   enable = true;
  #   type = "fcitx5";
  #   fcitx5.waylandFrontend = true;
  #   fcitx5.addons = with pkgs; [
  #     fcitx5-gtk
  #   ];
  # };

  # Configure console keymap
  console.keyMap = "de";
  services.solaar.enable = true;

  # hardware.logitech.wireless.enable = true;
  # hardware.logitech.wireless.enableGraphical = true;
}
