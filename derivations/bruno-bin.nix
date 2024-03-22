{
  # pkgs ? import (fetchTarball {
  #   url = "https://github.com/NixOS/nixpkgs/archive/4fe8d07066f6ea82cda2b0c9ae7aee59b2d241b3.tar.gz";
  #   sha256 = "sha256:06jzngg5jm1f81sc4xfskvvgjy5bblz51xpl788mnps1wrkykfhp";
  # }) {},
   lib, pkgs, ...
}:

pkgs.stdenv.mkDerivation rec {
  pname = "Bruno";
  version = "1.11.0";

  phases = ["installPhase"];
  installPhase = ''
    mkdir -p $out/Applications/${pname}.app
    cp -avi $src/Contents $out/Applications/${pname}.app/
  '';

  src = pkgs.fetchzip {
    url = "https://github.com/usebruno/bruno/releases/download/v${version}/bruno_${version}_x64_mac.zip";
    sha256 = "sha256-5nINOzmHfDr4kZJG/OIadkaYzy9DyT3IehAFgxTvz1o=";
    # sha256 = lib.fakeSha256;
  };

  meta = with lib; {
    description = "Bruno is a Fast and Git-Friendly Opensource API client, aimed at revolutionizing the status quo represented by Postman, Insomnia and similar tools out there.";
    homepage = "https://www.usebruno.com/";
    license = licenses.mit;
    mainProgram = "bruno";
    maintainers = with maintainers; [ alienman5k ];
  };

  platforms = lib.platforms.darwin;
}
