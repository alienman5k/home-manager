{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # html-tidy
    nodejs
    nodePackages.typescript
    nodePackages.vscode-json-languageserver
    nodePackages.typescript-language-server
  ];
}
