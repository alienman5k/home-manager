{
  # pkgs ? import (fetchTarball {
  #   url = "https://github.com/NixOS/nixpkgs/archive/4fe8d07066f6ea82cda2b0c9ae7aee59b2d241b3.tar.gz";
  #   sha256 = "sha256:06jzngg5jm1f81sc4xfskvvgjy5bblz51xpl788mnps1wrkykfhp";
  # }) {},
   lib, pkgs, ...
}:

pkgs.stdenv.mkDerivation rec {
  pname = "Bruno";
  version = "1.12.2";

  src = pkgs.fetchzip {
    url = "https://github.com/usebruno/bruno/releases/download/v${version}/bruno_${version}_x64_mac.zip";
    sha256 = "sha256-A1SJOAaqz/tKtjAbaqeALmW0L8IhzHimNccTM37tHt8=";
    # sha256 = lib.fakeSha256;
  };

  phases = ["installPhase"];
  installPhase = ''
    mkdir -p $out/Applications/${pname}.app
    cp -avi $src/Contents $out/Applications/${pname}.app/
  '';

  meta = {
    description = "Bruno is a Fast and Git-Friendly Opensource API client, aimed at revolutionizing the status quo represented by Postman, Insomnia and similar tools out there.";
    homepage = "https://www.usebruno.com/";
    license = lib.licenses.mit;
    mainProgram = "bruno";
    maintainers = with lib.maintainers; [ alienman5k ];
  };

  platforms = lib.platforms.darwin;
}