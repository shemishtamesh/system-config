{ config, pkgs, inputs, ... }:
let
  palette = config.lib.stylix.colors;
in
{
  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "reboot";
        action = "reboot";
        text = "reboot";
        keybind = "r";
      }
      {
        label = "logout";
        action = "logout";
        text = "logout";
        keybind = "o";
      }
      {
        label = "lock";
        action = "hyprlock";
        text = "lock";
        keybind = "l";
      }
      {
        label = "hibernate";
        action = "systemctl hibernate";
        text = "hibernate";
        keybind = "h";
      }
      {
        label = "suspend";
        action = "systemctl suspend";
        text = "suspend";
        keybind = "s";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "shutdown";
        keybind = "p";
      }
    ];
  };
}

