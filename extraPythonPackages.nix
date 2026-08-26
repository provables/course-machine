{
  course.extraPythonPackages = p: with p; [
    # Add Python packages from Nixpkgs
    # Search available packages at: https://search.nixos.org/packages?query=python313Packages
    # Write below the name after the dot.
    # For example, if one finds `python313Packages.sympy` in the above URL, then
    # simply write below: `sympy`.
    #
    # For example,
    sympy
  ];
}