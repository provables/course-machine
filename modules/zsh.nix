{ lib, pkgs, config, ... }: {
  home.packages = [
    pkgs.zsh-syntax-highlighting
  ];
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.eza = {
    enable = true;
  };
  programs.zsh = {
    enable = true;
    autosuggestion.enable = false;
    syntaxHighlighting.enable = false;
    plugins = [
      {
        name = "fzf-tab";
        src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
      }
    ];
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "fzf" ];
    };
    shellAliases = {
      l = "ls -la";
    };
  };

  programs.starship = {
    enable = true;
    package = pkgs.starship;
    enableZshIntegration = true;
  };

  programs.bat.enable = true;
  programs.less.enable = true;
  programs.lesspipe.enable = true;

  home.activation = {
    ensureZshActivation = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD /usr/bin/sudo ${pkgs.util-linux}/bin/chsh -s ${config.programs.zsh.package}/bin/zsh ${config.my.username}
    '';
  };
}
