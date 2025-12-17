{
  description = "Nix implementation of Root";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    systems.url = "github:nix-systems/default-linux";
  };

  outputs =
    {
      self,
      nixpkgs,
      systems,
    }:
    let
      inherit (nixpkgs) lib;
      forEachPkgs = f: lib.genAttrs (import systems) (system: f nixpkgs.legacyPackages.${system});
    in
    {
      packages = forEachPkgs (pkgs: {
        default = pkgs.callPackage ./rootapp.nix { };
      });

      devShells = forEachPkgs (pkgs: {
        default = pkgs.mkShell {
          inputsFrom = [ (pkgs.callPackage ./rootapp.nix { }) ];
        };
      });

      overlays.default = final: prev: {
        rootapp = prev.callPackage ./rootapp.nix { };
      };

      homeManagerModules.default = import ./module.nix self;
    };
}
