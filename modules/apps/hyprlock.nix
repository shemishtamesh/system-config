{ pkgs, config, ... }:
let
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
      size = "50, 50";
      outline_thickness = 0;
      inner_color = rgba "base01" "1";
      font_color = rgba "base07" "0"; # no typing indication
      fade_on_empty = true;
      fade_timeout = 1000;
      rounding = -1;
      placeholder_text = "";
      fail_text = "X";
      check_color = rgba "base09" "1";
      fail_color = rgba "base08" "1";
      halign = "center";
      valign = "bottom";
      position = "0, 90";
    };
    label = [
      {
        text = "cmd[update:1000] date";
        color = rgba "base02" "1";
        font_size = 22;
        position = "0, 50";
        halign = "center";
        valign = "bottom";
      }
      {
        text = "cmd[update:10000] acpi | awk '{print substr($0, index($0, $3))}'";
        color = rgba "base02" "1";
        font_size = 14;
        position = "0, 30";
        halign = "center";
        valign = "bottom";
      }
    ];
  };
}
