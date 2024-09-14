{ lib, pkgs, ... }:
let
  run-if-not-playing = pkgs.writeShellScript "run-if-not-playing" ''
    # check if any player has status "Playing"
    ${lib.getExe pkgs.playerctl} -a status | ${lib.getExe pkgs.ripgrep} Playing -q
    # only suspend if nothing is playing
    if [ $? == 1 ]; then
      $1
    fi
  '';
in
{
  services.hypridle.enable = true;
  services.hypridle.settings = {
    general = {
      lock_cmd = "${lib.getExe run-if-not-playing} pidof hyprlock || hyprlock"; # avoid starting multiple hyprlock instances.
      before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
      after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
    };
    listener = [
      {
        timeout = 15; # 2.5min.
        on-timeout = "${lib.getExe run-if-not-playing} 'brightnessctl -s set 1%'"; # set monitor backlight to minimum, avoid 0 on OLED monitor.
        on-resume = "brightnessctl -r"; # monitor backlight restore.
      }

      # turn off keyboard backlight
      {
        timeout = 15; # 2.5min.
        on-timeout = "${lib.getExe run-if-not-playing} brightnessctl -sd rgb:kbd_backlight set 0"; # turn off keyboard backlight.
        on-resume = "brightnessctl -rd rgb:kbd_backlight"; # turn on keyboard backlight.
      }

      {
        timeout = 30; # 5min
        on-timeout = "${lib.getExe run-if-not-playing} loginctl lock-session"; # lock screen when timeout has passed
      }

      {
        timeout = 33; # 5.5min
        on-timeout = "${lib.getExe run-if-not-playing} hyprctl dispatch dpms off"; # screen off when timeout has passed
        on-resume = "hyprctl dispatch dpms on"; # screen on when activity is detected after timeout has fired.
      }

      {
        timeout = 180; # 30min
        on-timeout = "${lib.getExe run-if-not-playing} systemctl suspend"; # suspend pc
      }
    ];
  };
}
