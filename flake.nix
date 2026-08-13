{
  description = "flake-parts configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    shell-utils.url = "github:waltermoreira/shell-utils";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { config, ... }: {
        debug = true;
        imports = [
          inputs.home-manager.flakeModules.home-manager
          inputs.shell-utils.flakeModule
          (flake-parts.lib.importApply
            ./modules/homeConfigurations.nix
            { inherit (config.my) system; }
          )
          ./user.nix
        ];
        flake.machineName = config.my.machineName;
      }
    );
}
