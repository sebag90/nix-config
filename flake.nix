{
  description = "Minimal Nix Flake for headless and container environments";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    helix.url = "github:helix-editor/helix";
    goosebutils.url = "github:sebag90/goosebutils";
  };

  outputs = { self, nixpkgs, flake-utils, helix, goosebutils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        headlessPackages = import ./packages/headless.nix { inherit pkgs helix goosebutils system; };

        containerPackages = headlessPackages ++ import ./packages/container.nix { inherit pkgs; };

      in {
        packages = {
          headless = pkgs.buildEnv {
            name = "headless-env";
            paths = headlessPackages;
          };

          container = pkgs.buildEnv {
            name = "container-env";
            paths = containerPackages;
          };

          default = pkgs.buildEnv {
            name = "default-env";
            paths = headlessPackages;
          };
        };
      }
    );
}
