self:
{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.programs.rootapp;

  inherit (pkgs.stdenv.hostPlatform) system;
  rootappPkg = self.packages.${system}.rootapp;
in
{
  options.programs.rootapp = {
    enable = lib.mkEnableOption "Enable Root" // {
      default = false;
    };
    package = lib.mkOption {
      type = lib.types.package;
      default = rootappPkg;
      defaultText = lib.literalExpression "rootapp";
      description = "The rootapp package to use";
    };

  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
