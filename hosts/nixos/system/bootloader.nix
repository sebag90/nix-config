{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # BIOS updater
  services.fwupd.enable = true;
}
