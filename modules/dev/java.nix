{ pkgs, ... }:
{
  home.packages = with pkgs; [
    #Decompiler
    cfr
    jd-gui
    # Build tools
    maven
    gradle
    # Language Server
    jdt-language-server
    # VSCode extensions used in neovim to allow debug and testing Java programs
    vscode-extensions.vscjava.vscode-java-debug
    vscode-extensions.vscjava.vscode-java-test
  ];
}
