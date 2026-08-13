{ lib, pkgs, config, shell-utils, ... }:
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
    runtimeInputs = with pkgs; [
      shell-utils.display
      gum
    ];
    text = ''
      [[ "$(id -u)" -eq "0" ]] && printf "Please, run as a regular user with sudo access" && exit 1
      sudo /usr/bin/chsh -s ${config.programs.zsh.package}/bin/zsh ${config.my.username} 
      sudo su -c '${installSelfUpdate}/bin/install-self-update' ${config.my.username}
      ${selfUpdateCmd}/bin/self-update
    '';
  };
  selfUpdateCmd = pkgs.writeShellApplication {
    name = "self-update";
    runtimeInputs = with pkgs; [
      coreutils
      git
      home-manager
    ];
    text = ''
      cd "$HOME"/.course-machine
      TEMP="$(mktemp -d)"
      cp user.nix "$TEMP"
      git stash || true
      git stash drop || true
      git pull origin main
      cp "$TEMP"/user.nix .
      home-manager switch \
        -b backup --flake "path:$(pwd)#${config.my.machineName}"
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
