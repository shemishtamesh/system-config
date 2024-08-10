{ pkgs, ... }:
let
  wallpaper = (import ../utils/theming.nix { inherit pkgs; }).wallpaper;
in
{
  services.hyprpaper.enable = true;
}
