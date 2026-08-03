{ pkgs, lib, ... }: {
  home.packages = [ pkgs.elan ];
  home.activation = {
    elanActivation = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      TOOLCHAIN=$(${pkgs.elan}/bin/elan show)
      if [ "$TOOLCHAIN" = "no active toolchain" ]; then
        echo "Setting default toolchain for Lean"
        $DRY_RUN_CMD ${pkgs.elan}/bin/elan default stable
      else
        echo "Toolchain already configured"
      fi
      ${pkgs.elan}/bin/lake --version
    '';
  };
}
