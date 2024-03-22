{ pkgs, lib, undmg, unzip , ... }:
# runCommand "long-running" {} ''
#     echo "Sleeping!"
#     sleep 15
#     echo "Finished sleeping" > $out
# ''
pkgs.stdenv.mkDerivation rec {
  pname = "Firefox Developer Edition";
  sname = "firefox";
  version = "124.0b4";

  sourceRoot = "${pname}.app";
  # sourceRoot = ".";
  nativeBuildInputs = [ undmg unzip ];
  phases = ["unpackPhase" "installPhase"];
  installPhase = ''
    # runHook preInstall
    mkdir -p $out/Applications/'${pname}.app'
    cp -avi * $out/Applications/'${pname}.app'
  '';

  src = pkgs.fetchurl {
    url = "https://ftp.mozilla.org/pub/devedition/releases/${version}/mac/en-US/Firefox%20${version}.dmg";
    sha256 = "sha256-1lHSPeq+sXsmcOc4Pgg6L5d6b+Gfz0fIi4sjLp2M73o=";
    # sha256 = lib.fakeSha256;
  };

  meta = with lib; {
    description = "Firefox Browser Developer Edition";
    homepage = "https://www.mozilla.org/en-US/firefox/developer/";
    license = licenses.mit;
    mainProgram = "firefox";
    maintainers = with maintainers; [ alienman5k ];
  };
  
  # inherit (pkgs.librewolf) meta;
  platforms = lib.platforms.darwin;
}
