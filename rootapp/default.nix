{
  appimageTools,
  fetchurl,
  icu,
  lib,
}:

let
  pname = "rootapp";
  version = "0.9.83";

  src = fetchurl {
    url = "https://installer.rootapp.com/installer/Linux/X64/Root.AppImage";
    hash = "sha256-HYnOaI7l0nnk79SqT1G2dOBYVViXA0wzyU7lTAf56ss=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: [ icu ];

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/Root.desktop $out/share/applications/${pname}.desktop
    install -m 444 -D ${appimageContents}/Root.png $out/share/icons/hicolor/512x512/apps/${pname}.png

    substituteInPlace $out/share/applications/${pname}.desktop \
    	--replace 'Exec=Root' 'Exec=${pname} %U'
  '';

  meta = {
    changelog = "https://www.rootapp.com/changelog";
    description = "Nix implementation of Root";
    homepage = "https://rootapp.com";
    # While the license is technically unfree, it messes with the build, so it's not included here.
    #license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    mainProgram = "rootapp";
  };
}
