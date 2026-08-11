{ ... }:
{
  # bar foo
  imports = [ ./modules/my.nix ];
  config = {
    my.system = "aarch64-linux";
    my.name = "Walter Moreira";
    my.username = "wmoreira";
    my.email = "wmoreira@tacc.utexas.edu";
    my.home = "/home/wmoreira";
    my.machineName = "ubuntu2";
  };
}
