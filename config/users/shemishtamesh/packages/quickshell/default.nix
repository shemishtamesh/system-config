{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    quickshell
    qt6.qtdeclarative
    qt6.qtwayland
  ];
  qt.enable = true;
  xdg.configFile = {
    "quickshell/overview".source = inputs.quickshell-overview;
    "quickshell/overview/config.json".text = builtins.toJSON {
      overview = {
        rows = 3;
        columns = 3;
        scale = 2;
        enable = true;
        hideEmptyRows = false;
      };
    };
  };
}
