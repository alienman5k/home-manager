{ config, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  xdg.configFile.nvim = {
    recursive = true;
    source = ./dotFiles/nvim;
    target = "nvim";
  };


  programs.helix = {
    enable = true;
    settings = {
      theme = "gruvbox";
      editor = {
        line-number = "relative";
        mouse = false;
        bufferline = "multiple";
      };
      editor.cursor-shape = {
        insert = "bar";
      };
    };
  };

  programs.emacs = {
    enable = true;
    extraConfig = ''
      (defvar am5k/emacs-config-file
        (expand-file-name "config.org" user-emacs-directory))

      (org-babel-load-file am5k/emacs-config-file)
    '';
  };

  home.file.emacs = {
    recursive = true;
    source = ./dotFiles/emacs;
    target = ".emacs.d";
  };
}
