{
  pkgs,
  lib,
  ...
}:
pkgs.stdenv.mkDerivation rec {
  pname = "Wezterm";
  version = "20240203-110809-5046fc22";

  phases = ["installPhase"];
  installPhase = ''
    mkdir -p $out/Applications
    echo $src
    cp -avi $src/Wezterm.app $out/Applications/
  '';

  postInstall = ''
    ln -s $out/Applications/Wezterm.app/Contents/MacOS/{wezterm,wezterm-gui} $out/bin
  '';

  src = pkgs.fetchzip {
    url = "https://github.com/wez/wezterm/releases/download/${version}/WezTerm-macos-${version}.zip";
    sha256 = "sha256-HKUC7T7VJ+3dDtbOoFc/kVUBUGstsAZn+IpD9oRIMXw=";
  };

  inherit (pkgs.wezterm) meta;
  platforms = lib.platforms.darwin;
}
