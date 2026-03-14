{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    quickshell
    qt6.qtdeclarative
    qt6.qtwayland
  ];
  qt.enable = true;
  xdg.configFile = {
    "quickshell/overview" = {
      source = inputs.quickshell-overview;
      recursive = true;
    };
    "quickshell/overview/config.json".text = builtins.toJSON {
      appearance.colorSource = "mutagen";
      overview = {
        rows = 3;
        columns = 3;
        scale = 0.25;
        enable = true;
        hideEmptyRows = false;
      };
    };
  };
}
