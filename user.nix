{ ... }:
{
  imports = [ ./modules/my.nix ];
  config = {
    my.system = "x86_64-linux";
    my.name = "Generic User";
    my.username = "ubuntu";
    my.email = "ubuntu@example.org";
    my.home = "/home/ubuntu";
    my.machineName = "ubuntu";
  };
}
