{pkgs, ...}: {
  # GNOME
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  environment.gnome.excludePackages = with pkgs; [
    cheese      # photo booth
    epiphany    # web browser
    gedit       # text editor
    yelp        # help viewer
  ];

  # COSMIC
  # services.displayManager.cosmic-greeter.enable = true;
  # services.desktopManager.cosmic.enable = true;

  # PANTHEON
  # services.xserver.enable = true;
  # services.desktopManager.pantheon.enable = true;
}
