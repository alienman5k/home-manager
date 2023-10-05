{ config, pkgs, ... }:
{
  # Alacritty
  programs.alacritty = {
    enable = false;
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
  xdg.configFile.wezterm = {
    recursive = true;
    source = ./dotFiles/wezterm;
    target = "wezterm";
  };

  #{{{
  # Kitty
  programs.kitty = {
    enable = true;
    font = {
      # name = "Fira Code Nerd Font";
      name = "BlexMono Nerd Font";
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
    # plugins = with pkgs.tmuxPlugins; [
      # {
      #   plugin = catppuccin;
      #   extraConfig = ''
      #   set -g @catppuccin_window_tabs_enabled on
      #   set -g @catppuccin_pill_theme_enabled off
      #   '';
      # }
    # ];
    extraConfig = ''
      # Neovim warnings
      set-option focus-events on
      # If tmux-256color is not available in Darwin, install local version https://github.com/tmux/tmux/issues/1257
      set-option -ga terminal-overrides ",*-256color*:Tc"
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

      # alienman5k theme
      set-option -g message-command-style bg=colour0,fg=colour7
      set-option -g message-style bg=colour0,fg=colour7
      set-option -g mode-style bg=colour1
      set-option -g status-justify left
      set-option -g status-left "  #{=28:session_name}  "
      set-option -g status-left-length 32
      set-option -g status-left-style "bg=colour10,fg=#000000,italics,bold"
      set-option -g status-right ""
      set-option -g status-justify centre
      # set-option -g status-right-style "bg=colour0"
      # set-option -g status-style "bg=#1b2229,fg=#bbc2cf"
      set-option -g status-style "bg=colour0,fg=colour7"
      set-option -g window-status-current-format " [#I] #W "
      #set-option -g window-status-current-style "bg=#51afef,fg=#282c34"
      set-option -g window-status-current-style "bg=colour4,fg=#000000,bold"
      set-option -g window-status-format " [#I] #W "
      set-option -g window-status-separator ""
      set-option -g window-status-style "bg=colour0,fg=colour15,bold,fill=colour0"
      set-option -g window-status-last-style "italics"
    '';
  };
}
