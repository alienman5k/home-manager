{ config, pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    defaultKeymap = "emacs";
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    history = {
      path = ".config/zsh/.zsh_history";
      share = true;
      save = 10000;
      size = 10000;
    };
    historySubstringSearch = {
      enable = true;
      # searchDownKey = "^[[B"; #Down key
      # searchUpKey = "^[[A"; #Up key
      searchUpKey = "^[[5~"; #PageUp key
      searchDownKey = "^[[6~"; #PageDown key
    };
    
    shellAliases = {
      ll = "ls -ltr --color";
      ".." = "cd ..";
      vim = "nvim";
      vi = "nvim";
    };

    sessionVariables = {
      ADE_SITE = "ade_phx";
      EDITOR = "nvim";
    };

    initExtra = ''
      WORDCHARS=""
      if [[ -f "$HOME/.config/zsh/plugins/functions.plugin.zsh" ]]; then
        source $HOME/.config/zsh/plugins/functions.plugin.zsh
      fi
      if [[ -f "$HOME/.config/zsh/plugins/profiles.plugin.zsh" ]]; then
        source $HOME/.config/zsh/plugins/profiles.plugin.zsh
      fi
    '';

    # plugins = [
    #   {
    #     name = "functions";
    #     # file = "functions.plugin.zsh";
    #     src = ./dotFiles/zsh/plugins;
    #   }
    #   {
    #     name = "profiles";
    #     # file = "profiles.plugin.zsh";
    #     src = ./dotFiles/zsh/plugins;
    #   }
    # ];
  };

  home.file.".config/zsh/plugins" = {
    source = ./dotFiles/zsh/plugins;
    recursive = true;
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      add_newline = true;
      scan_timeout = 30;
      command_timeout = 800;
      format = "$directory $git_branch $git_status $git_metrics $line_break$character";
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[✖](bold red)"; 
      };
      directory = {
        truncation_length = 2;
        truncate_to_repo = true;
        fish_style_pwd_dir_length = 1;
      };
    };
  };

  #Tmux https://github.com/tmux/tmux/wiki
  programs.tmux = {
    enable = true;
    shell = "/bin/zsh";
    baseIndex = 1;
    # newSession = true;
    escapeTime = 10;
    terminal = "xterm-256color";
    plugins = with pkgs.tmuxPlugins; [
      gruvbox
    ];
    extraConfig = ''
      # Neovim warnings
      set-option focus-events on
      set-option -ga terminal-overrides ",xterm-256color:Tc"

      set-option -g allow-rename off
      set-option -g renumber-windows on

      # vim-like pane switching
      bind -r k select-pane -U 
      bind -r j select-pane -D 
      bind -r h select-pane -L 
      bind -r l select-pane -R 

      # Switch windows
      bind -r N swap-window -t +1
      bind -r P swap-window -t -1
    '';
  };

}
