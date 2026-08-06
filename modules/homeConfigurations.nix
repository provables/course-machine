{ system }:
{ inputs, config, ... }:
let
  cfg = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    modules = [
      ./../user.nix
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
