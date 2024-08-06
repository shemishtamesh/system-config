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
            path = toString wallpaper;
            blur_passes = 2;
            contrast = 1;
            brightness = 0.5;
            vibrancy = 0.2;
            vibrancy_darkness = 0.2;
        };
    };
}
