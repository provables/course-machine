{ pkgs, ... }: {
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
}
