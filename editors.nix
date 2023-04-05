{ config, pkgs, ... }:
{
  # nixpkgs.overlays = [
  #   (import (builtins.fetchTarball {
  #     url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
  #   }))
  # ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    # package = pkgs.neovim-nightly;
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
        insert = "block";
      };
      editor.search = {
        smart-case = true;
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
