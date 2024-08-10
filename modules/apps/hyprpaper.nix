{ pkgs, inputs, config, ... }:
let
  wallpaper = (import ../utils/theming.nix { inherit pkgs; }).wallpaper;
in
{
  services.hyprpaper.enable = true;
  # services.hyprpaper.settings = {
  #   preload = [ "${wallpaper}" ];
  #   wallpaper = [ "eDP-1,${wallpaper}" ];
  # };
}
