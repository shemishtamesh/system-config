{
  lib,
  pkgs,
  config,
  ...
}:
let
  gaps = "2";
  rounding = "10";
  toggle-bar = pkgs.writeShellScriptBin "toggle-bar" ''
    ${pkgs.killall}/bin/killall .waybar-wrapped
    if [[ $? -eq 0 ]]; then
        hyprctl keyword general:border_size 0;
        hyprctl keyword general:gaps_in 0
        hyprctl keyword general:gaps_out 0
        hyprctl keyword decoration:rounding 0
        hyprctl keyword decoration:shadow:enabled 1
        hyprctl keyword decoration:shadow:range 50
        exit 0
    fi

    hyprctl keyword general:border_size 1;
    hyprctl keyword general:gaps_in ${gaps}
    hyprctl keyword general:gaps_out ${gaps}
    hyprctl keyword decoration:rounding ${rounding}
    hyprctl keyword decoration:shadow:enabled 0
    waybar
  '';
  utils = (import ../../general/utils.nix { inherit pkgs; });
  sync_external = utils.sync_external_monitor_brightness;
  notification-log = utils.notification-log;
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      monitor = [
        "eDP-1,1920x1080@60,1920x0,1"
        "HDMI-A-1,1920x1080@60,0x0,1"
      ];
      bind =
        [
          "$mod CTRL SHIFT, q, exit"

          "$mod SHIFT, w, killactive"

          "$mod, c, cyclenext"

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
          "$mod, V, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"
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

          "$mod, b, exec, ${lib.getExe toggle-bar}"

          ", XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
          ", XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous"
          ", XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"

          "$mod, XF86Reload, togglespecialworkspace, chat"
          "$mod SHIFT, XF86Reload, movetoworkspace, special:chat"
          "$mod, XF86AudioPlay, togglespecialworkspace, music"
          "$mod SHIFT, XF86AudioPlay, movetoworkspace, special:music"
          "$mod, 0, togglespecialworkspace, scratchpad"
          "$mod SHIFT, 0, movetoworkspace, special:scratchpad"
          "$mod, n, workspace, empty"
          "$mod, mouse_up, workspace, e-1"
          "$mod, mouse_down, workspace, e+1"
          "$mod, bracketleft, workspace, e-1"
          "$mod, bracketright, workspace, e+1"
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

        "CTRL, XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 1%+"
        "CTRL, XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 1%-"
        "CTRL SHIFT, XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 10%+"
        "CTRL SHIFT, XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 10%-"

        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-"
        "SHIFT, XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%+"
        "SHIFT, XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%-"
        ", XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 1%+ && ${sync_external}"
        ", XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 1%- && ${sync_external}"
        "SHIFT, XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 10%+ && ${sync_external}"
        "SHIFT, XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 10%- && ${sync_external}"
      ];
      bindlr = [ ", XF86Reload, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle" ];
      bindl = [
        "CTRL, XF86Reload, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ", XF86Reload, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_SINK@ toggle"
      ];
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
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

        "col.inactive_border" = lib.mkForce "0x00000000";
        "col.active_border" =
          with config.lib.stylix.colors;
          lib.mkForce "rgb(${base10}) rgb(${base11}) rgb(${base12}) rgb(${base13}) rgb(${base14}) rgb(${base15}) rgb(${base16}) rgb(${base17})";
      };
      cursor = {
        hide_on_key_press = true;
      };
      decoration = {
        rounding = rounding;
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
          "fade, 1, 10, linear"
          "workspaces, 1, 5, wind"
        ];
      };
      misc = {
        force_default_wallpaper = 1;
        disable_hyprland_logo = false;
      };
      windowrulev2 = [
        "workspace special:music silent, class:(spotify)"
        "workspace special:chat silent, class:(discord-screenaudio)"

        # no borders when there's only a single visible window
        "bordersize 0, floating:0, onworkspace:w[v1]"
        "rounding 0, floating:0, onworkspace:w[v1]"
        "bordersize 0, floating:0, onworkspace:f[1]"
        "rounding 0, floating:0, onworkspace:f[1]"
      ];
      workspace = [
        # no borders when there's only a single visible window
        "w[v1], gapsout:0, gapsin:0"
        "f[1], gapsout:0, gapsin:0"
      ];
      exec-once = [
        "hyprpaper"
        "waybar"
        "[workspace special:music silent] spotify"
        "[workspace special:chat silent] discord-screenaudio"
        "wl-paste --watch cliphist store"
        "${notification-log} $HOME/Documents/logs/notifications.txt"
        "${pkgs.playerctl}/bin/playerctld"
        "kdeconnect-indicator"
        "hypridle"
        "transmission-daemon"
      ];
    };
    systemd.variables = [ "--all" ]; # fixed kdeconnect clipboard sync
  };
}
