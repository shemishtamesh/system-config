{ pkgs, ... }:
let
  wallpaper = (import ../general/theming.nix { inherit pkgs; }).wallpaper;
in
{
  services.hyprpaper.enable = true;
  services.hyprpaper.settings = {
    wallpaper = [
      "DP-1,${wallpaper}"
    ];
  };
}
