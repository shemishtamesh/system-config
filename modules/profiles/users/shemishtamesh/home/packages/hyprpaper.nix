{
  shared,
  host,
  pkgs,
  ...
}:
{
  stylix.targets.hyprpaper.enable = false;
  home.packages = with pkgs; [ hyprpaper ];
  services.hyprpaper = {
    enable = true;
    settings.wallpaper = builtins.attrValues (
      builtins.mapAttrs (
        portname:
        {
          width,
          height,
          ...
        }:
        "${portname}, ${toString (shared.theme.wallpaper { inherit portname width height; })}"
      ) host.monitors
    );
  };
}
