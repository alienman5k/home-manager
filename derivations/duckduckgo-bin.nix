{ pkgs, lib, undmg, unzip , ... }:
# runCommand "long-running" {} ''
#     echo "Sleeping!"
#     sleep 15
#     echo "Finished sleeping" > $out
# ''
pkgs.stdenv.mkDerivation rec {
  pname = "DuckDuckGo";
  sname = "duckduckgo";
  version = "gl";

  sourceRoot = "${pname}.app";
  # sourceRoot = ".";
  nativeBuildInputs = [ undmg unzip ];
  phases = ["unpackPhase" "installPhase"];
  installPhase = ''
    # runHook preInstall
    mkdir -p $out/Applications/${pname}.app
    cp -avi * $out/Applications/${pname}.app
  '';

  src = pkgs.fetchurl {
    url = "https://staticcdn.duckduckgo.com/macos-desktop-browser/gl/${sname}.dmg";
    sha256 = "sha256-9bzufPBVGzUa91PAHiu65zyKQKtGZfPtx7RnutKtYjM=";
    # sha256 = lib.fakeSha256;
  };

  meta = with lib; {
    description = "Search and browse more privately with the DuckDuckGo browser. Unlike Chrome and other browsers, we don't track you.";
    homepage = "https://duckduckgo.com/app";
    license = licenses.mit;
    mainProgram = "DuckDuckGo";
    maintainers = with maintainers; [ alienman5k ];
  };
  
  # inherit (pkgs.librewolf) meta;
  platforms = lib.platforms.darwin;
}
