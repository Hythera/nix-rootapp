{
  pkgs ? import <nixpkgs> { },
}:
{
  rootapp = pkgs.callPackage ./rootapp.nix { };
}
