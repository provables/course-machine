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
      sudo /usr/sbin/sss_override user-add ${config.my.username} --shell ${config.programs.zsh.package}/bin/zsh
      sudo /usr/bin/systemctl restart sssd
      ${installSelfUpdate}/bin/install-self-update
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
      rm -rf "$HOME"/course-machine || true
      cd "$HOME"/.course-machine
      TEMP="$(mktemp -d)"
      cp {user,extraPackages,extraPythonPackages}.nix "$TEMP"
      git stash || true
      git stash drop || true
      git pull origin main
      cp "$TEMP"/{user,extraPackages,extraPythonPackages}.nix .
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
    course.extraPackages = lib.mkOption {
      type = with lib.types; listOf package;
      default = [];
      description = "List of extra packages from Nixpkgs";
    };
  };
  config = {
    home.packages = with pkgs; [
      pkg-config
      openssl
      fzf
      glibcLocalesUtf8
      iconv
      home-manager
      installSelfUpdate
      selfUpdateCmd
    ] ++ config.course.extraPackages;
    home.username = config.my.username;
    home.homeDirectory = config.my.home;
    home.stateVersion = "25.11";
    home.sessionVariables = {
      USER = config.home.username;
      PATH = "${config.home.homeDirectory}/.nix-profile/bin:$PATH";
    };
  };
}
