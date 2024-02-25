{
  pkgs,
  lib,
  ...
}:
pkgs.stdenv.mkDerivation rec {
  pname = "WezTerm";
  version = "20240203-110809-5046fc22";

  phases = ["installPhase" "postInstall"];
  installPhase = ''
    mkdir -p $out/Applications
    echo $src
    cp -avi $src/${pname}.app $out/Applications/
  '';

  postInstall = ''
    mkdir -p $out/bin
    ln -s $out/Applications/${pname}.app/Contents/MacOS/{wezterm,wezterm-gui} $out/bin/
  '';

  src = pkgs.fetchzip {
    url = "https://github.com/wez/wezterm/releases/download/${version}/${pname}-macos-${version}.zip";
    sha256 = "sha256-HKUC7T7VJ+3dDtbOoFc/kVUBUGstsAZn+IpD9oRIMXw=";
  };

  inherit (pkgs.wezterm) meta;
  platforms = lib.platforms.darwin;
}
