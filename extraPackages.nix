{ pkgs, ... }: {
  course.extraPackages = with pkgs; [
    # Add packages from Nixpkgs
    # For example:
    cowsay
  ];
}
