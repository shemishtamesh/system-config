{
  inputs,
  config,
  pkgs,
  lib,
  host,
  ...
}:
let
  sorted_monitors = builtins.sort (
    a: b: host.monitors.${a}.horizontal_offset < host.monitors.${b}.horizontal_offset
  ) (builtins.attrNames host.monitors);
  # the "center" monitor in the layout - used for anything the UI pinned to one
  # specific output, so it keeps pointing at the middle screen regardless of
  # which port that ends up being on a given host
  middle_monitor = builtins.elemAt sorted_monitors (builtins.length sorted_monitors / 2);

  wallpaper_monitor = builtins.mapAttrs (
    port: _:
    {
      directory = "~/Pictures/Wallpapers/${port}";
    }
    // lib.optionalAttrs (port == middle_monitor) {
      directory_light = "~/Pictures/Wallpapers";
    }
  ) host.monitors;
in
{
  imports = [
    inputs.noctalia.homeModules.default
  ];
  programs.noctalia = {
    enable = true;
    package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
    settings = {
      audio.enable_overdrive = true;

      bar = {
        order = [ "main" ];
        main = {
          background_opacity = config.stylix.opacity.desktop;
          capsule = true;
          center = [ "workspaces" ];
          end = [
            "privacy"
            "tray"
            "keyboard_layout"
            "brightness"
            "input_volume"
            "output_volume"
            "caffeine"
            "notifications"
          ];
          margin_ends = 50;
          padding = 0;
          reserve_space = false;
          shadow = false;
          smart_auto_hide = true;
          start = [
            "bar"
            "clock"
            "media"
            "bluetooth"
            "network"
            "group:g1"
          ];
          dead_zone.actions.middle = "settings-toggle";
          capsule_group = [
            {
              id = "g1";
              enabled = true;
              fill = "surface_variant";
              members = [
                "cpu"
                "RAM"
              ];
              opacity = 1.0;
              padding = 6.0;
            }
          ];
        };
      };

      brightness = {
        enable_ddcutil = true;
        minimum_brightness = 0.0;
        sync_all_monitors = true;
      };

      calendar.enabled = true;

      control_center = {
        sidebar = "full";
        calendar.show_week_numbers = true;
        shortcuts = [
          { type = "wifi"; }
          { type = "bluetooth"; }
          { type = "nightlight"; }
          { type = "notification"; }
          { type = "dark_mode"; }
          { type = "caffeine"; }
        ];
      };

      desktop_widgets = {
        enabled = false;
        schema_version = 2;
        widget_order = [ ];
      };

      dock = {
        active_monitor_only = true;
        enabled = true;
        launcher_position = "start";
        magnification_scale = 2.0;
        reserve_space = false;
        show_dots = true;
        smart_auto_hide = true;
      };

      hot_corners = {
        bottom_left.action = "launcher";
        bottom_right.action = "window_switcher";
        top_right.action = "control_center";
      };

      keybinds = {
        delete = [
          "Delete"
          "BackSpace"
        ];
        down = [
          "Down"
          "Ctrl+j"
        ];
        left = [
          "Left"
          "Ctrl+h"
        ];
        right = [
          "Right"
          "Ctrl+l"
        ];
        up = [
          "Up"
          "Ctrl+k"
        ];
      };

      location.auto_locate = true;

      lockscreen.allow_empty_password = true;

      notification = {
        offset_y = 40;
        position = "top_right";
      };

      osd = {
        offset_y = 40;
        position = "top_right";
        position_vertical = "center_right";
      };

      plugin_settings."noctalia/bitwarden" = {
        clear_clipboard_seconds = 30;
        login_open_near_click = true;
        login_placement = "attached";
        unlock_open_near_click = true;
        unlock_placement = "attached";
      };

      plugins = {
        enabled = [
          "noctalia/timer"
          "noctalia/translator"
          "noctalia/screen_recorder"
          "noctalia/bitwarden"
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

      shell = {
        clipboard_history_max_entries = 1000;
        date_format = "%A, %B, %x";
        external_ip_enabled = true;
        launch_apps_as_systemd_services = true;
        password_style = "random";
        polkit_agent = true;
        popup_shadows = false;
        screen_time_enabled = true;
        telemetry_enabled = true;
        time_format = "{:%T}";

        launcher.providers = {
          emoji.global = true;
          session.global = true;
          wallpaper.global = true;
          windows.global = true;
        };

        panel = {
          clipboard_placement = "attached";
          launcher_placement = "attached";
          launcher_position = "bottom_center";
          list_item_background = true;
          open_near_click_clipboard = true;
          open_near_click_control_center = true;
          open_near_click_launcher = true;
          open_near_click_session = true;
          open_near_click_wallpaper = true;
          polkit_placement = "attached";
          shadow = false;
          transparency_mode = "glass";
        };

        screenshot = {
          confirm_region = true;
          remember_last_region = true;
          show_cursor = true;
        };
      };

      theme.pure_black_dark = true;

      wallpaper = {
        directory = "~/Pictures/Wallpapers";
        enabled = true;
        per_monitor_directories = true;
        transition = [ "fade" ];
        transition_on_startup = true;
        monitor = wallpaper_monitor;
      };

      widget = {
        RAM = {
          show_glyph = false;
          show_value = false;
          stat = "ram_used";
          type = "sysmon";
        };
        bar = {
          show_idle_on_horizontal = false;
          type = "noctalia/timer:bar";
        };
        battery.enabled = false;
        cpu = {
          show_glyph = false;
          show_value = false;
        };
        nightlight.enabled = false;
        privacy.hide_inactive = true;
        session.enabled = false;
        settings.enabled = false;
        sysmon = {
          show_glyph = false;
          show_value = false;
        };
        weather.enabled = false;
        workspaces = {
          display = "name";
          empty_color = "on_surface";
          hide_when_empty = true;
          style = "focus_hint";
        };
      };
    };
  };
  home.packages = with pkgs; [
    gpu-screen-recorder
    bitwarden-cli
  ];
}
