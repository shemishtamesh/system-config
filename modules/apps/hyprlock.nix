{ pkgs, config, ... }:
let
  wallpaper = (import ../wallpaper.nix { inherit pkgs; inherit config; }).wallpaper;
in
{
    programs.hyprlock.enable = true;
    programs.hyprlock.settings = {
        general = {
            # grace = 60;
        };
        background = {
            path = toString wallpaper;
            blur_passes = 2;
            contrast = 1;
            brightness = 0.5;
            vibrancy = 0.2;
            vibrancy_darkness = 0.2;
        };
        input-field = {
            size = "250, 60";
            outline_thickness = 2;
            dots_size = 0.2;
            dots_spacing = 0.35;
            dots_center = true;
            outer_color = "rgba(0, 0, 0, 0)";
            inner_color = "rgba(0, 0, 0, 0.2)";
            font_color = "rgba(255, 255, 255, 255)";
            fade_on_empty = false;
            rounding = -1;
            check_color = "rgb(204, 136, 34)";
            placeholder_text = "<i><span foreground=\"##cdd6f4\">Input Password...</span></i>";
            hide_input = false;
            position = "0, -200";
            halign = "center";
            valign = "center";
        };
    };
}
