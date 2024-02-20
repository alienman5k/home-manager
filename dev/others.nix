{ pkgs, ... }:
{
  home.packages = with pkgs; [
    #Lua Language Server
    lua-language-server
    #Nix Language Server
    nil
  ];
}
