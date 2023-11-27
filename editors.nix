{ pkgs, ... }:
{
  # nixpkgs. = [
  #   (import (builtins.fetchTarball {
  #     url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
  #   }))
  # ];

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
    enable = false;
    settings = {
      theme = "solarized_dark";
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
    # package = pkgs.emacs-29;
    extraPackages = epkgs: [
      epkgs.catppuccin-theme
      epkgs.consult
      epkgs.corfu
      epkgs.doom-themes
      epkgs.ef-themes
      epkgs.eglot
      epkgs.evil 
      epkgs.evil-collection
      epkgs.evil-commentary
      epkgs.exec-path-from-shell
      epkgs.lua-mode
      epkgs.magit 
      epkgs.marginalia 
      epkgs.nix-mode
      epkgs.ns-auto-titlebar
      # epkgs.ob-mermaid
      epkgs.orderless
      epkgs.org-contrib
      epkgs.rainbow-delimiters
      epkgs.rust-mode
      epkgs.tempel
      epkgs.tree-sitter
      epkgs.tree-sitter-langs
      epkgs.use-package
      epkgs.vertico
      epkgs.vterm
      epkgs.which-key
    ];
    # package = pkgs.emacsMacport;
    # extraConfig = ''
    #   (defvar am5k/emacs-config-file
    #     (expand-file-name "config.org" user-emacs-directory))
    #
    #   (org-babel-load-file am5k/emacs-config-file)
    # '';
  };

  # home.file.emacs = {
  #   recursive = true;
  #   source = ./dotFiles/emacs;
  #   target = ".emacs.d";
  # };
}
