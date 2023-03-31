{ config, pkgs, ... }:
{
  programs.wezterm = {
    enable = true;
  };

  xdg.configFile.wezterm = {
    recursive = true;
    source = ./dotFiles/wezterm;
    target = "wezterm";
  };
}
