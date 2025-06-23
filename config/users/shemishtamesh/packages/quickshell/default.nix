{ pkgs, ... }:
{
  home.packages = with pkgs; [
    quickshell
  ];
  qt.enable = true;
  xdg.configFile.quickshell.source = ./quickshell;
}
