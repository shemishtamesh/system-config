{ pkgs, config, ... }:
let
  wallpaper = (import ../utils/theming.nix { inherit pkgs; inherit config; }).wallpaper;
in
{
  programs.hyprlock.enable = true;
  programs.hyprlock.settings = {
    general = {
      grace = 0;
    };
    background = {
      path = toString wallpaper;
      blur_passes = 3;
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
    label = [
      {
        text = "cmd[update:1000] echo \"$(date +\"%A, %B %d\")\"";
        color = "rgba(242, 243, 244, 0.75)";
        font_size = 22;
        font_family = "FiraCode";
        position = "0, 300";
        halign = "center";
        valign = "center";
      }
      {
        text = "cmd[update:1000] echo \"$(date + \"%-I:%M\")\"";
        color = "rgba(242, 243, 244, 0.75)";
        font_size = 95;
        font_family = "FiraCode";
        position = "0, 200";
        halign = "center";
        valign = "center";
      }
    ];

    # image {
    #     path = /home/justin/Pictures/profile_pictures/justin_square.png
    #     size = 100
    #     border_size = 2
    #     border_color = $foreground
    #     position = 0, -100
    #     halign = center
    #     valign = center
    # };
    # image {
    #     path = /home/justin/Pictures/profile_pictures/hypr.png
    #     size = 75
    #     border_size = 2
    #     border_color = $foreground
    #     position = -50, 50
    #     halign = right
    #     valign = bottom
    # };
    # label {
    #     monitor =
    #     text = cmd[update:1000] echo "$(/home/justin/Documents/Scripts/whatsong.sh)" 
    #     color = $foreground
    #     #color = rgba(255, 255, 255, 0.6)
    #     font_size = 18
    #     font_family = Metropolis Light, Font Awesome 6 Free Solid
    #     position = 0, 50
    #     halign = center
    #     valign = bottom
    # };
    # label {
    #     monitor =
    #     text = cmd[update:1000] echo "$(/home/justin/Documents/Scripts/whoami.sh)"
    #     color = $foreground
    #     font_size = 14
    #     font_family = JetBrains Mono
    #     position = 0, -10
    #     halign = center
    #     valign = top
    # };
    # label {
    #     monitor =
    #     text = cmd[update:1000] echo "$(/home/justin/Documents/Scripts/battery.sh)"
    #     color = $foreground
    #     font_size = 24
    #     font_family = JetBrains Mono
    #     position = -90, -10
    #     halign = right
    #     valign = top
    # };
    # label {
    #     monitor =
    #     text = cmd[update:1000] echo "$(/home/justin/Documents/Scripts/network-status.sh)"
    #     color = $foreground
    #     font_size = 24
    #     font_family = JetBrains Mono
    #     position = -20, -10
    #     halign = right
    #     valign = top
    # };
  };
}
