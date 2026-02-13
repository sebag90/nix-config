{
  users.users.seba = {
    isNormalUser = true;
    description = "seba";
    extraGroups = [ "networkmanager" "wheel" "scanner" "lp" "docker" "podman"];
  };
}
