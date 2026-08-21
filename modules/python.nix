{ pkgs, lib, config, ... }: {
  options = {
    course.extraPythonPackages = lib.mkOption {
      type = with lib.types; functionTo (listOf package);
      default = p: [ ];
      description = ''
        Function returning a list of Python packages to add the global Python environment.
      '';
    };
  };
  config = {
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
      ] ++ (config.course.extraPythonPackages p)))
      black
    ];
    programs.uv.enable = true;
  };
}
