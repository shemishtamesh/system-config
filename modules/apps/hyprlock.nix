{ pkgs, config, ... }:
let
  wallpaper = (import ../wallpaper.nix { inherit pkgs; inherit config; }).wallpaper;
in
{
    programs.hyprlock.enable = true;
    programs.hyprlock.settings = {
        general = {
            grace = 60;
        };
        background = {
            path = wallpaper;
        };
    };
}
