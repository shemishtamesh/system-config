{
  lib,
  pkgs,
  config,
  shared,
  host,
  inputs,
  ...
}:
let
  gaps = "0";
  rounding = "10";
  scripts = import ./scripts.nix { inherit pkgs gaps rounding; };
  sorted_monitors = builtins.sort (
    a: b: (host.monitors.${a}.horizontal_offset < host.monitors.${b}.horizontal_offset)
  ) (builtins.attrNames host.monitors);
in
{
  wayland.windowManager.hyprland =
    let
      flake_hyprland = inputs.hyprland.packages.${host.system};
    in
    {
      enable = true;
      package = flake_hyprland.hyprland;
      portalPackage = flake_hyprland.xdg-desktop-portal-hyprland;
      settings = {
        "$mod" = "SUPER";
        monitor = builtins.attrValues (
          builtins.mapAttrs (
            portname:
            {
              width,
              height,
              refresh_rate,
              horizontal_offset,
              vertical_offset,
              scaling,
            }:
            "${portname},"
            + "${toString width}x${toString height}@${toString refresh_rate},"
            + "${toString horizontal_offset}x${toString vertical_offset},"
            + "${toString scaling}"
          ) host.monitors
        );
        bind = [
          "$mod CTRL SHIFT, q, exit"

          "$mod SHIFT, w, killactive"
          "$mod SHIFT, q, forcekillactive"

          "$mod, c, cyclenext"
          "$mod SHIFT, c, cyclenext, prev"

          "$mod, f, fullscreen, 1"
          "$mod SHIFT, f, fullscreen, 0"
          "$mod CTRL, f, fullscreenstate, -1 2"
          "$mod, t, togglefloating, 0"

          "$mod, r, togglesplit"

          "$mod, SPACE, exec, rofi -show combi"
          "$mod SHIFT, minus, exec, rofi -show drun -modi 'drun'"
          "$mod, Tab, exec, rofi -show window -modi 'window'"
          ", Cancel, exec, rofi -show char -modi 'char:rofimoji --use-icons -a=copy -f all'"
          '', XF86Favorites, exec, rofi -show calc -modi 'calc' -calc-command "echo -n '{result}' | wl-copy"''
          "$mod, v, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"
          "$mod, g, exec, rofi-rbw"
          "$mod CTRL, c, exec, hyprpicker --autocopy"
          "$mod, s, exec, hyprshot -m window"
          "$mod SHIFT, s, exec, hyprshot -m region"
          "$mod, RETURN, exec, kitty --execute tmux"
          "$mod, i, exec, zen"
          "$mod SHIFT, i, exec, zen --private-window"
          "$mod, d, exec, obsidian"
          "$mod SHIFT, d, exec, lorien"

          "$mod, Escape, exec, wlogout"
          "$mod, grave, exec, hyprlock & sleep 0.5 && systemctl suspend"

          "$mod, b, exec, ${scripts.toggle-bar}"

          "$mod, XF86Reload, togglespecialworkspace, chat"
          "$mod SHIFT, XF86Reload, movetoworkspace, special:chat"
          "$mod, XF86AudioPlay, togglespecialworkspace, music"
          "$mod SHIFT, XF86AudioPlay, movetoworkspace, special:music"
          "$mod, 0, togglespecialworkspace, scratchpad"
          "$mod SHIFT, 0, movetoworkspace, special:scratchpad"
          "$mod, e, workspace, emptym"
          "$mod SHIFT, e, movetoworkspace, emptym"
          "$mod, o, workspace, previous"

          "$mod, mouse_down, workspace, m+1"
          "$mod, mouse_up, workspace, m-1"
          "$mod CTRL, mouse_down, exec, hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor | awk '/^float.*/ {print $2 * 1.1}')"
          "$mod CTRL, mouse_up, exec, hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor | awk '/^float.*/ {new = $2 * 0.9; if (new < 1) new = 1; print new}')"

          "$mod, bracketleft, workspace, m-1"
          "$mod SHIFT, bracketright, movetoworkspace, m+1"
          "$mod SHIFT, bracketleft, movetoworkspace, m-1"
          "$mod, bracketright, workspace, m+1"
          "$mod, n, focusmonitor, -1"
          "$mod, p, focusmonitor, +1"
          "$mod SHIFT, n, movewindow, mon:-1"
          "$mod SHIFT, p, movewindow, mon:+1"
          "$mod ALT, n, movecurrentworkspacetomonitor, -1"
          "$mod ALT, p, movecurrentworkspacetomonitor, +1"
        ]
        ++ (builtins.concatLists (
          builtins.genList (
            i:
            let
              num = i + 1;
            in
            [
              "$mod, ${toString num}, workspace, ${toString num}"
              "$mod SHIFT, ${toString num}, movetoworkspace, ${toString num}"
            ]
          ) 9
        ))
        ++ (builtins.concatLists (
          builtins.genList (
            i:
            let
              num = i + 1;
            in
            [ "$mod CTRL, ${toString num}, exec, hyprctl keyword cursor:zoom_factor ${toString num}" ]
          ) 9
        ));
        binde = [
          "$mod, semicolon, exec, dunstctl close"
          "$mod SHIFT, semicolon, exec, dunstctl close-all"
          "$mod CTRL, semicolon, exec, dunstctl history-pop"
          "$mod ALT, semicolon, exec, dunstctl set-paused toggle"

          "$mod, h, movefocus, l"
          "$mod, j, movefocus, d"
          "$mod, k, movefocus, u"
          "$mod, l, movefocus, r"
          "$mod SHIFT, h, swapwindow, l"
          "$mod SHIFT, j, swapwindow, d"
          "$mod SHIFT, k, swapwindow, u"
          "$mod SHIFT, l, swapwindow, r"
          "$mod CTRL, h, movewindow, l"
          "$mod CTRL, j, movewindow, d"
          "$mod CTRL, k, movewindow, u"
          "$mod CTRL, l, movewindow, r"
          "$mod ALT, h, resizeactive, -10 0"
          "$mod ALT, j, resizeactive, 0 10"
          "$mod ALT, k, resizeactive, 0 -10"
          "$mod ALT, l, resizeactive, 10 0"
          "$mod ALT SHIFT, h, resizeactive, -1 0"
          "$mod ALT SHIFT, j, resizeactive, 0 1"
          "$mod ALT SHIFT, k, resizeactive, 0 -1"
          "$mod ALT SHIFT, l, resizeactive, 1 0"

          ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+"
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-"
          "SHIFT, XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%+"
          "SHIFT, XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%-"

          "CTRL, XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 1%+"
          "CTRL, XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 1%-"
          "CTRL SHIFT, XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 10%+"
          "CTRL SHIFT, XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 10%-"
          "ALT, XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 100%"
          "ALT, XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 40%"
        ];
        bindlr = [
          ", XF86Reload, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ];
        bindl = [
          "CTRL, XF86Reload, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
          ", XF86Reload, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_SINK@ toggle"

          ", XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
          ", XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous"
          ", XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
        ];
        bindle = [
          '', XF86MonBrightnessUp, exec, ${shared.scripts.set_brightness} "+ 1"''
          '', XF86MonBrightnessDown, exec, ${shared.scripts.set_brightness} "- 1"''
          ''SHIFT, XF86MonBrightnessUp, exec, ${shared.scripts.set_brightness} "+ 10"''
          ''SHIFT, XF86MonBrightnessDown, exec,  ${shared.scripts.set_brightness} "- 10"''
          ''CTRL, XF86MonBrightnessUp, exec, ${shared.scripts.set_brightness} "100"''
          ''CTRL, XF86MonBrightnessDown, exec,  ${shared.scripts.set_brightness} "0"''
        ];
        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];
        binds = {
          scroll_event_delay = 0;
          hide_special_on_workspace_change = true;
        };
        input = {
          kb_layout = "us,il";
          kb_options = "grp:alt_space_toggle";
        };
        general = {
          gaps_in = gaps;
          gaps_out = gaps;
          border_size = 1;

          allow_tearing = false;

          resize_on_border = true;

          "col.inactive_border" = lib.mkForce "0x00000000"; # transparent
          "col.active_border" =
            with config.lib.stylix.colors;
            lib.mkForce "rgb(${base08}) rgb(${base0A}) rgb(${base0B}) rgb(${base0C}) rgb(${base0D}) rgb(${base0E})";
        };
        cursor = {
          hide_on_key_press = true;
        };
        ecosystem = {
          no_update_news = true;
          no_donation_nag = true;
          enforce_permissions = false;
        };
        permission = [
          "${pkgs.hyprlock}/bin/hyprlock, screencopy, allow"
          "${pkgs.grim}/bin/grim, screencopy, allow"
        ];
        decoration = {
          inherit rounding;
          shadow.enabled = false;
        };
        dwindle = {
          preserve_split = true;
        };
        animations = {
          bezier = [
            "wind, 0.05, 0.9, 0.1, 1.05"
            "winIn, 0.1, 1.1, 0.1, 1.1"
            "winOut, 0.3, -0.3, 0, 1"
            "linear, 1, 1, 1, 1"
          ];
          animation = [
            "windows, 1, 6, wind, slide"
            "windowsIn, 1, 6, winIn, slide"
            "windowsOut, 1, 6, winOut, slide"
            "windowsMove, 1, 6, wind, slide"
            "border, 1, 1, linear"
            "borderangle, 1, 100, linear, loop"
            "fade, 1, 5, linear"
            "fadeIn, 1, 1, linear"
            "fadeOut, 1, 10, linear"
            "workspaces, 1, 5, wind"
          ];
        };
        misc = {
          force_default_wallpaper = 1;
          disable_hyprland_logo = false;
          new_window_takes_over_fullscreen = 2;
        };
        windowrulev2 = [
          "workspace special:music silent, class:(spotify)"
          "workspace special:chat silent, class:(discord|vesktop|Altus|Slack)"

          # no borders when there's only a single visible window
          "bordersize 0, floating:0, onworkspace:w[v1]"
          "rounding 0, floating:0, onworkspace:w[v1]"
          "bordersize 0, floating:0, onworkspace:f[1]"
          "rounding 0, floating:0, onworkspace:f[1]"

          # open aseprite in tiled mode by default
          "tile, class:(Aseprite)"
        ];
        workspace = [
          # no borders when there's only a single visible window
          "w[v1], gapsout:0, gapsin:0"
          "f[1], gapsout:0, gapsin:0"
        ]
        ++ (
          (
            monitor_portnames: workspace_numbers:
            lib.lists.imap0 (
              i: key:
              ''${toString key}, monitor:${
                lib.lists.elemAt monitor_portnames (
                  i * lib.lists.length monitor_portnames / lib.lists.length workspace_numbers
                )
              }''
            ) workspace_numbers
          )
          sorted_monitors
          (lib.range 1 9)
        );
        device = {
          name = "wacom-one-by-wacom-s-pen";
          output = builtins.elemAt sorted_monitors (builtins.length sorted_monitors / 2);
          left_handed = true;
        };
        exec-once = [
          "${pkgs.hyprpaper}"
          "waybar"
          "zen"
          "[workspace special:music silent] spotify"
          "[workspace special:chat silent] vesktop"
          "[workspace special:chat silent] altus"
          "[workspace special:chat silent] slack"
          "wl-paste --watch cliphist store"
          "${scripts.notification-log} $HOME/Documents/logs/notifications.txt"
          "${pkgs.playerctl}/bin/playerctld"
          "kdeconnect-indicator"
          "hypridle"
          "${pkgs.hypridle}/bin/hypridle"
          "transmission-daemon"
          "${pkgs.easyeffects}/bin/easyeffects --gapplication-service"
        ];
      };
      systemd.variables = [ "--all" ]; # fixed kdeconnect clipboard sync
    };
  home.packages = with pkgs; [ hyprland-qtutils ];
}
