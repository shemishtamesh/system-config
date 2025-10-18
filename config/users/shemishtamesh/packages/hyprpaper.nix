{
  shared,
  host,
  ...
}:
let
  wallpapers = builtins.attrValues (
    builtins.mapAttrs (
      portname:
      {
        width,
        height,
        ...
      }:
      {
        path = toString (
          shared.theme.wallpaper {
            inherit portname width height;
            # background = false;
          }
        );
        inherit portname;
      }
    ) host.monitors
  );
in
{
  stylix.targets.hyprpaper.enable = false;
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = map (wallpaper: wallpaper.path) wallpapers;
      wallpaper = map (wallpaper: "${wallpaper.portname}, ${wallpaper.path}") wallpapers;
    };
  };
}
