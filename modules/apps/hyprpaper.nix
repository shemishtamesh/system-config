{ pkgs, inputs, config, lib, ... }:
let
  wallpaper = (import ../utils/theming.nix { inherit pkgs; inherit lib; }).wallpaper;
in
{
  services.hyprpaper.enable = true;
}
