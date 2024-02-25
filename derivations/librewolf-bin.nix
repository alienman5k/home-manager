{ pkgs, lib, undmg, unzip , ... }:
# runCommand "long-running" {} ''
#     echo "Sleeping!"
#     sleep 15
#     echo "Finished sleeping" > $out
# ''
pkgs.stdenv.mkDerivation rec {
  pname = "LibreWolf";
  sname = "librewolf";
  version = "123.0-1";

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
    url = "https://gitlab.com/api/v4/projects/44042130/packages/generic/${sname}/${version}/${sname}-${version}-macos-x86_64-package.dmg";
    sha256 = "sha256-hvXJy8OFlWzeZzCY/4PJBdLcNftOLRxlih34yO+Q8j0=";
    # sha256 = lib.fakeSha256;
  };

  meta = with lib; {
    description = "This project is a custom and independent version of Firefox, with the primary goals of privacy, security and user freedom.";
    homepage = "https://librewolf.net";
    license = licenses.mit;
    mainProgram = "librewolf";
    maintainers = with maintainers; [ alienman5k ];
  };
  
  # inherit (pkgs.librewolf) meta;
  platforms = lib.platforms.darwin;
}
