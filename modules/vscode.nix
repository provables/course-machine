{ lib, pkgs, config, ... }:
let
  vscodeTargetPlatforms = {
    x86_64-linux = "linux-x64";
    aarch64-linux = "linux-arm64";
  };
  user = config.my.username;
  targetPlatform = vscodeTargetPlatforms.${config.my.system};
  settings = pkgs.runCommand "settings.json" { } ''
    substitute ${./../files/settings.json} $out \
      --subst-var-by user ${user}\
      --subst-var-by zsh ${config.programs.zsh.package}
  '';
  extensionsId = [
    "ms-python.black-formatter"
    "tamasfe.even-better-toml"
    "leanprover.lean4"
    "ms-python.vscode-pylance"
    "ms-python.python"
    "ms-python.debugpy"
    "ms-python.vscode-python-envs"
  ];
  extensionsCmds = builtins.concatStringsSep "\n"
    (builtins.map
      (ext: ''
        ${pkgs.vscode}/bin/code --extensions-dir "$HOME"/.vscode-server/extensions/ \
            --install-extension ${ext} --force
      '')
      extensionsId);
  installExtensions = pkgs.writeShellApplication {
    name = "install-extensions";
    runtimeInputs = with pkgs; [ jq moreutils ];
    text = ''
      mkdir -p "$HOME"/.vscode-server/{extensions,data/Machine}
      cp ${settings} "$HOME"/.vscode-server/data/Machine/settings.json
      chmod u+rw -R "$HOME"/.vscode-server
      unset VSCODE_IPC_HOOK_CLI
      ${extensionsCmds}
      jq 'map(.metadata.isApplicationScoped = true)' \
        "$HOME"/.vscode-server/extensions/extensions.json \
        | sponge "$HOME"/.vscode-server/extensions/extensions.json 
    '';
  };
in
{
  home.packages = [ pkgs.vscode ];
  home.activation = {
    vscodeExtensionsActivation = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD ${installExtensions}/bin/install-extensions
    '';
  };
}
