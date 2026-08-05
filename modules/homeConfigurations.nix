{ system }:
{ inputs, config, ... }:
{
  config = {
    flake.homeConfigurations.${config.my.machineName} = inputs.home-manager.lib.homeManagerConfiguration {
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
  };
}
