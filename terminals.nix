{ config, pkgs, ... }:
{
  # Alacritty
  programs.alacritty = {
    enable = true;
  };
  xdg.configFile.alacritty = {
    recursive = true;
    source = ./dotFiles/alacritty;
    target = "alacritty";
  };
  # Wezterm
  programs.wezterm = {
    enable = false;
  };
  xdg.configFile.wezterm = {
    recursive = true;
    source = ./dotFiles/wezterm;
    target = "wezterm";
  };
}
