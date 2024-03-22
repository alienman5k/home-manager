{ config, pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    defaultKeymap = "emacs";
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history = {
      path = "${config.xdg.dataHome}/zsh/zsh_history";
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
      ".." = "cd ..";
      vi = "nvim";
      ls = "ls --color";
      # pass_work = "PASSWORD_STORE_DIR=${config.xdg.dataHome}/work-password-store pass";
    };

    sessionVariables = {
      EDITOR = "nvim";
    };

    initExtraBeforeCompInit = ''
      fpath=($HOME/.config/zsh/plugins/completions $fpath)
    '';

    initExtra = ''
      bindkey "^[[3~" delete-char
      WORDCHARS=""
      if [[ -f "$HOME/.config/zsh/plugins/functions.plugin.zsh" ]]; then
        source $HOME/.config/zsh/plugins/functions.plugin.zsh
      fi
      if [[ -f "$HOME/.config/zsh/plugins/profiles.plugin.zsh" ]]; then
        # Set exports and aliases
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
    source = ../dotFiles/zsh/plugins;
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

}
