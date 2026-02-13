{pkgs, ...}:
{
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];
  # # Optional: force NixOS to ignore the DNS provided by your router's DHCP
  # networking.networkmanager.dns = "none";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;
  boot.extraModprobeConfig = ''
    options iwlwifi power_save=0
    options iwlwifi uapsd_disable=1
  '';
  systemd.services.restart-nm-after-resume = {
    description = "Restart NetworkManager after suspend";
    wantedBy = [ "post-resume.target" ];
    after = [ "post-resume.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.systemd}/bin/systemctl restart NetworkManager";
    };
  };

}
