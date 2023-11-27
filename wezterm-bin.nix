{
  pkgs,
  lib,
  ...
}:
pkgs.stdenv.mkDerivation rec {
  pname = "Wezterm";
  version = "20230712-072601-f4abf8fd";

  phases = ["installPhase"];
  installPhase = ''
    mkdir -p $out/Applications
    cp -avi $src/Wezterm.app $out/Applications/
  '';

  postInstall = ''
    ln -s $out/Applications/Wezterm.app/Contents/MacOS/{wezterm,wezterm-gui} $out/bin
  '';

  src = pkgs.fetchzip {
    url = "https://github.com/wez/wezterm/releases/download/${version}/WezTerm-macos-${version}.zip";
    sha256 = "sha256-8PHHTVjcFDQ0Ic1UpUnMoYtSlxL1e/15zo5Jk9Sqb5E=";
  };

  inherit (pkgs.wezterm) meta;
  platforms = lib.platforms.darwin;
}
