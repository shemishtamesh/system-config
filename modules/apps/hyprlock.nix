{ pkgs, config, ... }:
let
  palette = config.lib.stylix.colors;
  rgba = (import ../utils/functions.nix { inherit pkgs; }).rgba config.lib.stylix.colors;
  wallpaper = (import ../utils/theming.nix { inherit pkgs; }).wallpaper;
in
{
  programs.hyprlock.enable = true;
  programs.hyprlock.settings = {
    general = {
      hide_cursor = true;
    };
    background = {
      path = toString wallpaper;
      blur_passes = 3;
      brightness = 0.5;
    };
    input-field = {
      size = "250, 60";
     uoutline_thickness = 0;
      outer_color = palette.base00;
      inner_color = palette.base03;
      font_color = "${rgba "base07" "0"}";  # no typing indication
      fade_on_empty = true;
      rounding = -1;
      halign = "center";
      valign = "bottom";
      position = "0, 50";
    };
    label = [
      {
        text = "cmd[update:1000] echo \"$(date +\"%A, %B %d\")\"";
        # color = "rgba(242, 243, 244, 0.75)";
        font_size = 22;
        position = "0, 300";
        halign = "center";
        valign = "center";
      }
      {
        text = "cmd[update:1000] echo \"$(date + \"%-I:%M\")\"";
        # color = "rgba(242, 243, 244, 0.75)";
        font_size = 95;
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
