{ inputs, config, ... }:
{
  config = {
    flake.homeConfigurations.${config.my.machineName} = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs { system = "aarch64-linux"; };
      modules = [
        ./../user.nix
        ./base.nix
        ./lean.nix
        ./git.nix
        ./zsh.nix
        ./vim.nix
      ];
    };
  };
}
