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
    cp -avi $src/Wezterm.app $out/Applications/
    echo "Copied fiel to $out/Applications/"
  '';

  postInstall = ''
    mkdir -p $HOME/Applications/My Apps/
    osascript -e 'tell application "Finder" to make alias file to POSIX file "$out/Applications/Wezterm.app" at POSIX file "~/Applications/My Apps/"'
    echo "Made alias from $out/Applications/ to ~/Applications/My Apps/"
  '';

  src = pkgs.fetchzip {
    url = "https://github.com/wez/wezterm/releases/download/${version}/WezTerm-macos-${version}.zip";
    sha256 = "sha256-HKUC7T7VJ+3dDtbOoFc/kVUBUGstsAZn+IpD9oRIMXw=";
  };

  inherit (pkgs.wezterm) meta;
  platforms = lib.platforms.darwin;
}
