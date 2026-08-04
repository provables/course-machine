{ pkgs, config, ... }: {
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
}
