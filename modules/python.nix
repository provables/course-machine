{ pkgs, ... }: {
  home.packages = with pkgs; [
    (python313.withPackages (p: [
      p.jupyter
      p.requests
      p.pandas
      p.numpy
      p.scikit-learn
      p.matplotlib
      p.tensorflow
      p.keras
    ]))
    black
  ];
  programs.uv.enable = true;
}
