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
    enable = true;
    enableBashIntegration = false;
    enableZshIntegration = false;
    # package = pkgs.callPackage ./wezterm-bin.nix { };
  };
  # xdg.configFile.wezterm = {
  #   recursive = true;
  #   source = ./dotFiles/wezterm;
  #   target = "wezterm";
  # };

  #{{{
  # Kitty
  programs.kitty = {
    enable = true;
    font = {
      # name = "Fira Code Nerd Font";
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };
    # theme = "Gruvbox Dark";
    theme = "Catppuccin-Mocha";
    settings = {
      # Shell Integration
      shell_integration = "no-cursor";
      # Cursor
      cursor = "none";
      cursor_shape = "block";
      cursor_blink_interval = 0;
      # Background
      background_opacity = "0.92";
      background_blur = 15;
      # Tab Bar
      tab_bar_edge = "top";
      tab_title_template = "{index}: {title} ";
      tab_bar_style = "powerline";
      tab_powerline_style = "round";
      # Window 
      hide_window_decorations = "titlebar-only";
      # macos_titlebar_color = "system";
    };
    extraConfig = ''
      map cmd+plus change_font_size all +1.0
      map cmd+equals change_font_size all +1.0
      map cmd+minus change_font_size all -1.0
      map cmd+0 change_font_size all 0
      map cmd+shift+enter toggle_maximized
    '';
  };
  #}}}

  #Tmux https://github.com/tmux/tmux/wiki
  programs.tmux = {
    enable = true;
    shell = "/bin/zsh";
    baseIndex = 1;
    # newSession = true;
    escapeTime = 10;
    # terminal = "screen-256color";
    terminal = "tmux-256color";
    keyMode = "vi";
    prefix = "C-Space";
    plugins = with pkgs.tmuxPlugins; [
      # gruvbox
      catppuccin
    ];
    extraConfig = ''
      # Neovim warnings
      set-option focus-events on
      # If tmux-256color is not available in Darwin, install local version https://github.com/tmux/tmux/issues/1257
      set-option -ga terminal-overrides ',*-256color*:Tc'
      set-option -sg escape-time 10
      set-option -g focus-events on

      set-option -g allow-rename off
      set-option -g allow-passthrough on
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
