{ pkgs, lib, undmg, unzip , ... }:
# runCommand "long-running" {} ''
#     echo "Sleeping!"
#     sleep 15
#     echo "Finished sleeping" > $out
# ''
pkgs.stdenv.mkDerivation rec {
  pname = "chromium";
  sname = "ungoogled-chromium";
  version = "92.0.4515.131-1";

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
    url = "https://github.com/kramred/ungoogled-chromium-macos/releases/download/92.0.4515.131-1.1_x86-64/ungoogled-chromium_92.0.4515.131-1.1_x86-64-macos.dmg";
    sha256 = "sha256-6XZPkhltQ3kx9VWQIm7cGrJ1NHt3TMpaYP1XciJ2LS0=";
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
