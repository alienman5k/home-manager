{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "imarmole";
  home.homeDirectory = "/Users/imarmole";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    alacritty
    cargo
    cfr
    fd
    fzf
    gitui
    gradle
    jd-gui
    jq
    maven
    nodejs
    p7zip
    plantuml
    ripgrep
    rustc
    rust-analyzer
    rustfmt
    tmux
    html-tidy
    wget
    #Fonts
    fira
    fira-code
    jetbrains-mono
    # roboto-mono
    # ubuntu_font_family
    # (nerdfonts.override {
    #   fonts = [ "SauceCodePro" ];
    # })

    #End Fonts
  ];

  programs.git = {
    enable = true;
    userName = "Ignacio Marmolejo";
    userEmail = "ignacio.marmolejo@oracle.com";
    extraConfig = {
      core = {
        editor = "nvim";
      };
      pull = {
        ff = "only";
      };
      init = {
        defaultBranch = "main";
      };
    };
    ignores = [
      ".DS_Store"
      "*~"
      "*.swp"
    ];
  };

  programs.bat =  {
    enable = true;
    config = {
      theme = "gruvbox-dark";
    };
  };

  xdg.configFile.alacritty = {
    recursive = true;
    source = ./dotFiles/alacritty;
    target = "alacritty";
  };

  imports = [
    ./shells.nix
    ./editors.nix
    ./terminals.nix
  ];
}
