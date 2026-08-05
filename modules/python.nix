{ pkgs, ... }: {
  home.packages = with pkgs; [
    python314
    black
  ];
  programs.uv.enable = true;
}
