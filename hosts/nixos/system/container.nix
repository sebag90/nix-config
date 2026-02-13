# {
#   virtualisation.docker.enable = true;
# }
{
  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other.
    };
  };
  systemd.services.podman-restart = {
    wantedBy = [ "multi-user.target" ];
  };
}
