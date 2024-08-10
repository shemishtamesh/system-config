{ pkgs, inputs, config, ... }:
let
  wallpaper = (import ../utils/theming.nix { inherit pkgs; }).imagesFromScheme.wallpaper;
in
{
  services.hyprpaper.enable = true;
}
