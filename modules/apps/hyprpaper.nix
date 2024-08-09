{ pkgs, inputs, config, ... }:
let
  wallpaper = (import ../utils/theming.nix { inherit pkgs; inherit config; }).wallpaper;
in
{
  services.hyprpaper.enable = true;
}
