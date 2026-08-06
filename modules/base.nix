{ lib, pkgs, config, ... }:
let
  setupMachineCmd = pkgs.writeShellApplication {
    name = "setup-machine";
    text = ''
      [[ "$(id -u)" -ne "0" ]] && printf "Please, run as root\n" && exit 1
      # shellcheck disable=SC2016
      /usr/bin/su -c \
        '${pkgs.nix}/bin/nix run home-manager/master switch -- -b backup --flake path:$(pwd)#${config.my.machineName}' \
        ${config.my.username}
      /usr/bin/chsh -s ${config.programs.zsh.package}/bin/zsh ${config.my.username}
    '';
  };
in
{
  options = { 
    setupMachine = lib.mkOption {
      type = lib.types.package;
      default = setupMachineCmd;
      description = "Command for setting up the machine";
    };
  };
  config = {
    home.packages = with pkgs; [
      pkg-config
      openssl
      fzf
      glibcLocalesUtf8
    ];
    home.username = config.my.username;
    home.homeDirectory = config.my.home;
    home.stateVersion = "25.11";
    home.sessionVariables = {
      USER = config.home.username;
      PATH = "${config.home.homeDirectory}/.nix-profile/bin:$PATH";
    };
  };
}
