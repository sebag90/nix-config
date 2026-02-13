{ config, hostname, dotfiles_dir, ... }:

let
  secretsPath = "${config.home.homeDirectory}/${dotfiles_dir}/nix/hosts/${hostname}/secrets.nix";
  secrets = if builtins.pathExists secretsPath then import secretsPath else {userEmail="dummy";};
in {
  programs.git = {
    enable = true;
    settings = {
      push.autoSetupRemote = "true";
      user.email = secrets.userEmail;
    };
  };
}
