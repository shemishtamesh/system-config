{ pkgs, ... }:
{
  home.packages = with pkgs; [
    quickshell
    qt6.qtdeclarative
  ];
  qt.enable = true;
  xdg.configFile.quickshell.source = ./quickshell;
}
