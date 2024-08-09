{ pkgs, inputs, config, ... }:
let
  wallpaper = config.lib.stylix.image;
in
{
  services.hyprpaper.enable = true;
  services.hyprpaper.settings = {
    preload = [ "${wallpaper}" ];
    wallpaper = [ "eDP-1,${wallpaper}" ];
  };
}
