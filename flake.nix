{
  description = "My NixOS Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";

    dotfiles.url = "github:sebag90/dotfiles";
    ghostty.url = "github:ghostty-org/ghostty";
    helix.url = "github:helix-editor/helix";
    goosebutils.url = "github:sebag90/goosebutils";

    solaar = {
      url = "https://flakehub.com/f/Svenum/Solaar-Flake/*.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ nixpkgs, home-manager, nix-darwin, flake-utils, solaar, ... }:
    let
      mkPkgs = system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

      mkHome = { system, hostname, homeFile }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = mkPkgs system;
          extraSpecialArgs = {
            dotfiles = inputs.dotfiles;
            helix = inputs.helix;
            goosebutils = inputs.goosebutils;
            dotfiles_dir = ".config/dotfiles";
            inherit hostname;
          };
          modules = [ ./hosts/common/allowunfree.nix homeFile ];
        };
    in flake-utils.lib.eachDefaultSystem (system: {
      ## ─────────────────────────────────────────────
      ## Home Manager
      ## ─────────────────────────────────────────────
      homeConfigurations = {
        container = mkHome {
          inherit system;
          hostname = "container";
          homeFile = ./hosts/container/home.nix;
        };

        headless = mkHome {
          inherit system;
          hostname = "headless";
          homeFile = ./hosts/headless/home.nix;
        };

        laptop = mkHome {
          inherit system;
          hostname = "laptop";
          homeFile = ./hosts/laptop/home.nix;
        };
      };
    }) // {
      ## ─────────────────────────────────────────────
      ## NixOS
      ## ─────────────────────────────────────────────
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/nixos/configuration.nix
            ./hosts/nixos/hardware-configuration.nix
            ./hosts/common/allowunfree.nix

            solaar.nixosModules.default
            home-manager.nixosModules.home-manager

            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.seba = import ./hosts/nixos/home.nix;
            }
          ];
        };
      };

      ## ─────────────────────────────────────────────
      ## macOS (nix-darwin)
      ## ─────────────────────────────────────────────
      darwinConfigurations = {
        mac = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./hosts/mac/configuration.nix
            ./hosts/common/allowunfree.nix

            home-manager.darwinModules.home-manager

            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.sebastiano = import ./hosts/mac/home.nix;

              home-manager.extraSpecialArgs = {
                dotfiles = inputs.dotfiles;
                helix = inputs.helix;
                goosebutils = inputs.goosebutils;
                dotfiles_dir = ".config/dotfiles";
                hostname = "mac";
              };
            }
          ];
        };
      };
    };

}
