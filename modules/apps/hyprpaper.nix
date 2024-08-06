{ pkgs, inputs, config, ... }:
let
  wallpaper = (import ../wallpaper.nix {}).wallpaper ;
in
{
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ "${wallpaper}" ];
      wallpaper = [ "eDP-1,${wallpaper}" ];
    };
  };
}
