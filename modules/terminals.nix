{ config, pkgs, ... }:
{
  # Alacritty
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        size = 14.0;
        normal = {
          family = "FiraCode Nerd Font";
          style = "Regular";
        };
        italic = {
          style = "Italic";
        };
      };
      window = {
        decorations = "buttonless";
        dynamic_title = true;
        opacity = 0.95;
        startup_mode = "Maximized";
        dimensions.columns = 180;
        dimensions.lines = 50;
        padding.x = 5;
        padding.y = 2;
      };
      keyboard.bindings = [
        { key = "B"; mods = "Alt"; chars = "\\u001Bb"; }
        { key = "F"; mods = "Alt"; chars = "\\u001Bf"; }
        { key = "Return"; mods = "Control"; action = "ToggleMaximized"; }
        { key = "Return"; mods = "Control|Shift"; action = "ToggleFullscreen"; }
      ];
      scrolling.history = 10000;
    };
  };

  # Wezterm
  programs.wezterm = {
    enable = false;
    enableBashIntegration = false;
    enableZshIntegration = false;
    extraConfig = builtins.readFile ../dotFiles/wezterm/wezterm.lua;
    package = pkgs.callPackage ../derivations/wezterm-bin.nix { };
  };

  # Kitty
  programs.kitty = {
    enable = true;
    font = {
      # name = "Fira Code Nerd Font";
      name = "BlexMono Nerd Font";
      size = 14;
    };
    shellIntegration.enableZshIntegration = false;
    theme = "GitHub Dark";
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
      tab_bar_style = "fade";
      # tab_bar_style = "powerline";
      # tab_powerline_style = "slanted";
      active_tab_background = "#710daa";
      # Window 
      hide_window_decorations = "titlebar-only";
      window_padding_width = 1;
      # macos_titlebar_color = "system";
      macos_option_as_alt = "yes";
    };
    keybindings = {
      "ctrl+enter" = "toggle_maximized";
      "cmd+plus" = "change_font_size all +1.0";
      "cmd+equals" = "change_font_size all +1.0";
      "cmd+minus" = "change_font_size all -1.0";
      "cmd+0" = "change_font_size all 0";
      "cmd+shift+i" = "set_tab_title"; # Default in mac but I tend to forget the mapping
    };
  };

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
      bind -r C-k select-pane -U
      bind -r C-j select-pane -D
      bind -r C-h select-pane -L
      bind -r C-l select-pane -R

      # Change Next and Previous windows to be repeatable
      bind -r C-n next-window
      bind -r C-p previous-window

      # Switch windows
      bind -r N swap-window -t +1 \; next-window
      bind -r P swap-window -t -1 \; previous-window

      # Reload file changes
      bind r source-file $HOME/.config/tmux/tmux.conf \; display "Configuration Reloaded!"

      # alienman5k theme
      source $HOME/.config/tmux/themes/alienman5k.conf
    '';
  };
  xdg.configFile.tmux = {
    enable = config.programs.tmux.enable;
    recursive = true;
    source = ../dotFiles/tmux;
    target = "tmux";
  };
}
