{ pkgs, ... }:
{
  home.packages = with pkgs;
  [
    # GUI Apps
    # raycast # Spotligh alternative
    # Custom Derivations
    (callPackage ../derivations/bruno-bin.nix { })
    # (callPackage ../derivations/librewolf-bin.nix { })
    # (callPackage ../derivations/firefoxdev-bin.nix { })
  ];
}
