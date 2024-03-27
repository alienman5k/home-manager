{ lib, pkgs, ... }:
{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "obsidian-1.5.11"
  ];

  home.packages = with pkgs;
  [
    # GUI Apps
    # raycast # Spotligh alternative
    # Custom Derivations
    # (callPackage ../derivations/bruno-bin.nix { })
    # (callPackage ../derivations/librewolf-bin.nix { })
    # (callPackage ../derivations/firefoxdev-bin.nix { })
    bruno
    # obsidian
  ];
}
