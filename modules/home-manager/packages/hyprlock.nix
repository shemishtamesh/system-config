{
  pkgs,
  ...
}:
let
  wallpaper = (import ../../general/theming.nix { inherit pkgs; }).wallpaper;
in
{
  programs.hyprlock.enable = true;
  programs.hyprlock.settings = {
    general = {
      hide_cursor = true;
      no_fade_in = true;
    };
    background = {
      path = toString wallpaper;
      blur_passes = 3;
      brightness = 0.5;
    };
    input-field = {
      size = "50, 50";
      outline_thickness = 0;
      fade_on_empty = true;
      fade_timeout = 1000;
      rounding = -1;
      placeholder_text = "";
      fail_text = "X";
      halign = "center";
      valign = "bottom";
      position = "0, 90";
    };
    label = [
      {
        text = "cmd[update:1000] date '+%Y-%m-%d %H:%M:%S'";
        font_size = 22;
        position = "0, 50";
        halign = "center";
        valign = "bottom";
      }
      {
        text = "cmd[update:10000] ${pkgs.acpi}/bin/acpi | awk '{print substr($0, index($0, $3))}'";
        font_size = 14;
        position = "0, 30";
        halign = "center";
        valign = "bottom";
      }
    ];
  };
}
