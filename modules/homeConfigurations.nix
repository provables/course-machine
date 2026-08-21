{ system }:
{ inputs, config, moduleWithSystem, ... }:
let
  cfg = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    modules = [
      ./../user.nix
      ./../extraPythonPackages.nix
      ./../extraPackages.nix
      (
        moduleWithSystem (
          { config, ...}:
          {
            _module.args.shell-utils = config.shell-utils;
          }
        )
      )
      ./base.nix
      ./lean.nix
      ./git.nix
      ./zsh.nix
      ./vim.nix
      ./python.nix
      ./vscode.nix
    ];
  };
in
{
  config = {
    systems = [ "x86_64-linux" "aarch64-linux" ];
    flake.homeConfigurations.${config.my.machineName} = cfg;
    perSystem.packages.default = cfg.config.setupMachine;
  };
}
