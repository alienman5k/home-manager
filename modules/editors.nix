{ config, ... }:
{

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
  };
  # Only link neovim config files if the program is enabled
  xdg.configFile.nvim = {
    enable = config.programs.neovim.enable;
    recursive = true;
    source = ../dotFiles/nvim;
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
    extraPackages = epkgs: [
      epkgs.cape
      epkgs.catppuccin-theme
      epkgs.consult
      epkgs.corfu
      epkgs.doom-themes
      epkgs.ef-themes
      # epkgs.eglot
      epkgs.evil 
      epkgs.evil-collection
      epkgs.evil-commentary
      epkgs.exec-path-from-shell
      epkgs.general
      epkgs.lua-mode
      epkgs.magit 
      epkgs.marginalia 
      epkgs.markdown-mode
      epkgs.nix-mode
      epkgs.nix-ts-mode
      epkgs.ns-auto-titlebar
      # epkgs.ob-mermaid
      epkgs.orderless
      epkgs.org-contrib
      epkgs.org-roam
			# epkgs.password-store
			# epkgs.password-store-otp
      epkgs.rainbow-delimiters
      epkgs.rust-mode
      epkgs.tempel
      epkgs.tempel-collection
      epkgs.eglot-tempel
      epkgs.eglot-java
      # epkgs.tree-sitter
      # epkgs.tree-sitter-langs
      epkgs.use-package
      epkgs.vertico
      epkgs.vterm
      epkgs.which-key
    ];
    # extraConfig = builtins.readFile ./dotFiles/emacs/init.el;
    # package = pkgs.emacsMacport;
    # extraConfig = ''
    #   (defvar am5k/emacs-config-file
    #     (expand-file-name "config.org" user-emacs-directory))
    #
    #   (org-babel-load-file am5k/emacs-config-file)
    # '';
  };
  # init.el is only linked if emacs is enabled
  home.file.emacs = {
    enable = config.programs.emacs.enable;
    source = ../dotFiles/emacs/init.el;
    target = ".emacs.d/init.el";
  };
}
