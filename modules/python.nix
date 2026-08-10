{ pkgs, ... }: {
  home.packages = with pkgs; [
    (python314.withPackages (p: [
      p.jupyter
      p.requests
    ]))
    black
  ];
  programs.uv.enable = true;
}
