{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    quickshell
    qt6.qtdeclarative
    qt6.qtwayland
  ];
  qt.enable = true;
  xdg.configFile.quickshell.source = inputs.quickshell-overview;
}
