{
  inputs,
  config,
  pkgs,
  host,
  ...
}:
let
  wallpaper_monitor = builtins.mapAttrs (port: _: {
    directory = "~/Pictures/Wallpapers/${port}";
  }) host.monitors;

  wallpaper_set_hooks = map (
    port: "noctalia msg wallpaper-set ${port} ~/Pictures/Wallpapers/${port}/wallpaper.png"
  ) (builtins.attrNames host.monitors);
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
          center = [ "taskbar" ];
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
          dead_zone.actions = {
            middle = "settings-toggle";
            scroll_down = "workspace-switch next";
            scroll_up = "workspace-switch prev";
          };
          capsule_group = [
            {
              id = "g1";
              enabled = true;
              fill = "surface_variant";
              members = [
                "cpu_usage"
                "cpu_temp"
                "gpu_usage"
                "gpu_temp"
                "gpu_vram"
                "ram_used"
                "disk_used"
                "disk_free"
                "net_rx"
                "net_tx"
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
        sync_all_monitors = false;
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

      hooks.started = wallpaper_set_hooks;

      hot_corners = {
        bottom_left.action = "launcher";
        bottom_right.action = "window_switcher";
        top_right.action = "control_center";
      };

      keybinds = {
        delete = [
          "Delete"
          "Ctrl+BackSpace"
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
        position = "center_right";
        border = false;
      };

      osd = {
        position = "bottom_center";
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

      widget =
        let
          sysmonStat = stat: {
            show_glyph = false;
            show_value = false;
            inherit stat;
            type = "sysmon";
          };
        in
        {
          cpu_usage = sysmonStat "cpu_usage";
          cpu_temp = sysmonStat "cpu_temp";
          gpu_usage = sysmonStat "gpu_usage";
          gpu_temp = sysmonStat "gpu_temp";
          gpu_vram = sysmonStat "gpu_vram";
          ram_used = sysmonStat "ram_used";
          disk_used = sysmonStat "disk_used";
          disk_free = sysmonStat "disk_free";
          net_rx = sysmonStat "net_rx";
          net_tx = sysmonStat "net_tx";

          bar = {
            show_idle_on_horizontal = false;
            type = "noctalia/timer:bar";
          };
          battery.enabled = false;
          nightlight.enabled = false;
          privacy.hide_inactive = true;
          session.enabled = false;
          settings.enabled = false;
          taskbar = {
            empty_color = "tertiary";
            group_by_workspace = true;
            group_single_icon_per_app = true;
          };
          weather.enabled = false;
          workspaces = {
            display = "name";
            empty_color = "on_surface";
            hide_when_empty = true;
            style = "regular";
          };
        };
    };
  };
  home.packages = with pkgs; [
    gpu-screen-recorder
    bitwarden-cli
    ddcutil
  ];
}
