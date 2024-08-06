{ pkgs, inputs, config, ... }:
let
  wallpaper = (import ../wallpaper.nix { inherit pkgs; inherit config; }).wallpaper;
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
