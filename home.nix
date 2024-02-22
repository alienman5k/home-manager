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

  # Home Manage Search Options link: https://mipmip.github.io/home-manager-option-search/

  home.packages = with pkgs; [
    eza
    fd
    fzf
    jq
    oci-cli
    p7zip
    pandoc
    plantuml
    ripgrep
    tmux
    wget
    # vscode-extensions.vadimcn.vscode-lldb #codelldb
    #Fonts
    fira
    fira-code
    iosevka
    jetbrains-mono
    # monaspace
    # roboto-mono
    # ubuntu_font_family
    (nerdfonts.override {
      fonts = [ "FiraCode" "JetBrainsMono" "IBMPlexMono" ];
    })
    #End Fonts
    # Custom Derivations
    (callPackage ./derivations/bruno-bin.nix { })
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

  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        scrollHeight = 2;
      };
    };
  };

  programs.gitui = {
    enable = false;
  };

  programs.bat =  {
    enable = true;
    config = {
      theme = "gruvbox-dark";
    };
  };

  programs.password-store = {
    enable = true;
    package = pkgs.pass.withExtensions (exts: [
      exts.pass-otp
      exts.pass-import
      exts.pass-audit
      exts.pass-checkup
      exts.pass-update
    ]);
    settings = {
      PASSWORD_STORE_DIR = "${config.xdg.dataHome}/password-store";
      PASSWORD_STORE_CLIP_TIME = "60";
      PASSWORD_STORE_GENERATED_LENGTH = "24";
    };
  };

  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.dataHome}/gnupg";
  };


  imports = [
    ./modules/dev/java.nix
    ./modules/dev/rust.nix
    ./modules/dev/go.nix
    ./modules/dev/js.nix
    ./modules/dev/others.nix
    ./modules/shells.nix
    ./modules/editors.nix
    ./modules/terminals.nix
  ];
}
