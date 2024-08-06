{ pkgs, inputs, config, ... }:
{
  imports = [ ../wallpaper.nix ];
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ "${wallpaper}" ];
      wallpaper = [ "eDP-1,${wallpaper}" ];
    };
  };
}
