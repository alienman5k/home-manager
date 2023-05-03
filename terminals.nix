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

  #Tmux https://github.com/tmux/tmux/wiki
  programs.tmux = {
    enable = true;
    shell = "/bin/zsh";
    baseIndex = 1;
    # newSession = true;
    escapeTime = 10;
    # terminal = "xterm-256color";
    terminal = "screen-256color";
    plugins = with pkgs.tmuxPlugins; [
      gruvbox
    ];
    extraConfig = ''
      # Neovim warnings
      set-option focus-events on
      set-option -ga terminal-overrides ',*-256color*:Tc'

      set-option -g allow-rename off
      set-option -g renumber-windows on

      # vim-like pane switching
      bind -r k select-pane -U 
      bind -r j select-pane -D 
      bind -r h select-pane -L 
      bind -r l select-pane -R 

      # Switch windows
      bind -r N swap-window -t +1 \; next-window
      bind -r P swap-window -t -1 \; previous-window
    '';
  };
}
