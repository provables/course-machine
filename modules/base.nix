{ lib, pkgs, config, ... }:
let
  installSelfUpdate = pkgs.writeShellApplication {
    name = "install-self-update";
    text = ''
      rm -rf "$HOME"/.course-machine
      ${pkgs.git}/bin/git clone https://github.com/provables/course-machine.git "$HOME"/.course-machine
      cp user.nix "$HOME"/.course-machine
    '';
  };
  setupMachineCmd = pkgs.writeShellApplication {
    name = "setup-machine";
    text = ''
      [[ "$(id -u)" -ne "0" ]] && printf "Please, run as root\n" && exit 1
      # shellcheck disable=SC2016
      /usr/bin/su -c \
        'env PATH=$HOME/.nix-profile/bin:$PATH ${pkgs.home-manager}/bin/home-manager switch -b backup --flake path:$(pwd)#${config.my.machineName}' \
        ${config.my.username}
      /usr/bin/chsh -s ${config.programs.zsh.package}/bin/zsh ${config.my.username}
      /usr/bin/su -c '${installSelfUpdate}/bin/install-self-update' ${config.my.username}
    '';
  };
  selfUpdateCmd = pkgs.writeShellApplication {
    name = "self-update";
    runtimeInputs = [ pkgs.coreutils pkgs.git ];
    text = ''
      cd "$HOME"/.course-machine
      TEMP="$(mktemp -d)"
      cp user.nix "$TEMP"
      git stash
      git stash drop
      git pull origin main
      cp "$TEMP"/user.nix .
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
      home-manager
      installSelfUpdate
      selfUpdateCmd
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
