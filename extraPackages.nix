{ pkgs, ... }: {
  course.extraPackages = with pkgs; [
    # Add packages from Nixpkgs
    # Search available packages at: https://search.nixos.org/packages
    #
    # For example:
    cowsay
  ];
}
