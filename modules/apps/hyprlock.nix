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
      size = "20, 20";
      outline_thickness = 0;
      inner_color = rgba "base01" "1";
      font_color = rgba "base07" "0"; # no typing indication
      fade_on_empty = true;
      fade_timeout = 1000;
      rounding = -1;
      placeholder_text = "";
      fail_text = "";
      check_color = palette.base09;
      fail_color = palette.base08;
      halign = "center";
      valign = "top";
      position = "0, 70";
    };
    label = [
      {
        text = "cmd[update:1000] echo $(date)";
        color = rgba "base02" "1";
        font_size = 22;
        position = "0, -70";
        halign = "center";
        valign = "bottom";
      }
      # {
      #   text = "cmd[update:10000] acpi";
      #   color = rgba "base02" "1";
      #   font_size = 14;
      #   position = "0, -40";
      #   halign = "center";
      #   valign = "bottom";
      # }
    ];
  };
}
