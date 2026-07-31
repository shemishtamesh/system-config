{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.noctalia.homeModules.default
  ];
  programs.noctalia = {
    enable = true;
    package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
    settings = {
      shell = {
        panel = {
          shadow = false;
          launcher_placement = "floating";
          launcher_position = "bottom_center";
        };
      };
      audio.enable_overdrive = true;
      bar.main = {
        smart_auto_hide = true;
        start = [
          { type = "noctalia/timer:bar"; }
          { type = "clock"; }
          { type = "sysmon"; }
          { type = "network"; }
          { type = "bluetooth"; }
          { type = "active_window"; }
          { type = "media"; }
        ];
        center = [
          { type = "workspaces"; }
        ];
        end = [
          { type = "tray"; }
          { type = "privacy"; }
          { type = "volume"; }
          { type = "brightness"; }
          { type = "keyboard_layout"; }
          { type = "notifications"; }
          { type = "caffeine"; }
          { type = "control-center"; }
        ];
      };
      control_center = {
        shortcuts = [
          { type = "wifi"; }
          { type = "bluetooth"; }
          { type = "screen_recorder"; }
          { type = "notification"; }
          { type = "power_profile"; }
          { type = "caffeine"; }
          { type = "nightlight"; }
        ];
        calendar.show_week_numbers = true;
      };
      dock.enabled = true;
      osd.position = "bottom_center";
      notification.position = "top_right";
      calendar.enabled = true;
      wallpaper = {
        enabled = true;
        directory = "~/Pictures/Wallpapers";
        transition = [ "fade" ];
      };
      brightness = {
        enable_ddcutil = true;
        minimum_brightness = 0.0;
      };
      desktop_widgets.enabled = true;
      plugins = {
        enabled = [
          "noctalia/timer"
          "noctalia/translator"
          "noctalia/screen_recorder"
        ];
        source = [
          {
            name = "official";
            kind = "git";
            location = "https://github.com/noctalia-dev/official-plugins";
            enabled = true;
          }
        ];
      };
    };
  };
  home.packages = with pkgs; [ gpu-screen-recorder ];
}
