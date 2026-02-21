{
  lib,
  pkgs,
  shared,
  host,
  config,
  inputs,
  ...
}:
let
  gaps = "5";
  rounding = "10";
  scripts = import ./scripts.nix { inherit pkgs gaps rounding host; };
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

        # # TODO: REMOVE THIS AFTER IGPU ISSUE IS RESOLVED
        # debug = {
        #   disable_logs = false;
        #   gl_debugging = true;
        # };
        # env = [ "AQ_DRM_DEVICES,/dev/dri/card2" ];

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

          # "$mod SHIFT, Tab, overview:toggle" # Hyprspace
          # "$mod, Tab, exec, rofi -show window -modi 'window'"
          # "$mod, SPACE, exec, rofi -show combi"
          # "$mod SHIFT, minus, exec, rofi -show drun -modi 'drun'"
          # ", Cancel, exec, rofi -show char -modi 'char:rofimoji --use-icons -a=copy -f all'"
          # '', XF86Favorites, exec, rofi -show calc -modi 'calc' -calc-command "echo -n '{result}' | wl-copy"''
          # "$mod, v, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"
          # "$mod, g, exec, rofi-rbw"
          "$mod, SPACE, exec, noctalia-shell ipc call launcher toggle"
          "$mod CTRL, c, exec, hyprpicker --render-inactive --autocopy"
          "$mod, s, exec, hyprshot --freeze --mode region"
          "$mod SHIFT, s, exec, hyprshot --freeze --mode window"
          "$mod CTRL, s, exec, hyprshot --freeze --mode output"
          "$mod, RETURN, exec, wezterm start tmux"
          "$mod, i, exec, zen-twilight"
          "$mod SHIFT, i, exec, zen-twilight --private-window"
          "$mod, d, exec, obsidian"
          "$mod SHIFT, d, exec, lorien"

          "$mod, w, exec, killall wshowkeys || wshowkeys -a bottom"

          "$mod, Escape, exec, noctalia-shell ipc call sessionMenu toggle"
          "$mod, grave, exec, noctalia-shell ipc call sessionMenu lockAndSuspend"

          "$mod, a, exec, noctalia-shell ipc call idleInhibitor toggle"

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
          ''$mod CTRL, 0, exec, hyprctl --quiet keyword cursor:zoom_disable_aa $(echo "1 - $(hyprctl getoption cursor:zoom_disable_aa | awk '/^int.*/ {print $2}')" | ${pkgs.bc}/bin/bc)''
          "$mod CTRL, mouse_down, exec, hyprctl --quiet keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor | awk '/^float.*/ {print $2 * 1.1}')"
          "$mod CTRL, mouse_up, exec, hyprctl --quiet keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor | awk '/^float.*/ {new = $2 * 0.9; if (new < 1) new = 1; print new}')"

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
          "$mod, semicolon, exec, noctalia-shell ipc call notifications dismissOldest"
          "$mod SHIFT, semicolon, exec, noctalia-shell ipc call notifications dismissAll"
          "$mod CTRL, semicolon, exec, noctalia-shell ipc call notifications toggleHistory"
          "$mod ALT, semicolon, exec, noctalia-shell ipc call notifications toggleDND"

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
          "ALT, XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 30%"
        ];
        bindlr = [ ", XF86Reload, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle" ];
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

          "col.active_border" = lib.mkForce "rgba(${config.lib.stylix.colors.base05}7f)";
          "col.inactive_border" = lib.mkForce "0x00000000"; # transparent
        };
        cursor = {
          hide_on_key_press = true;
          zoom_disable_aa = true;
          no_hardware_cursors = 0; # fix double cursor
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
            "fade, 1, 5, linear"
            "fadeIn, 1, 1, linear"
            "fadeOut, 1, 10, linear"
            "workspaces, 1, 5, wind"
            "specialWorkspace, 1, 5, wind, slidevert"
          ];
        };
        misc = {
          force_default_wallpaper = 1;
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
        };
        layerrule = [ "match:namespace quickshell, no_anim on" ];
        windowrule = [
          # open aseprite in tiled mode by default
          "match:class Aseprite, tile true"
        ];
        workspace = [
          # no borders when there's only a single visible window
          "w[v1], rounding:false, border:false"

          # move specific apps to their special workspaces
          "special:music silent, class:([sS]potify)"
          "special:chat silent, class:([dD]iscord|[vV]esktop|Altus|Slack)"

          # no borders when there's only a single visible window
          "w[v1], gapsout:0, gapsin:0"
          "f[1], gapsout:0, gapsin:0"
        ]
        ++ (
          (
            monitor_portnames: workspace_numbers:
            lib.lists.imap0 (
              i: key:
              "${toString key}, monitor:${
                lib.lists.elemAt monitor_portnames (
                  i * lib.lists.length monitor_portnames / lib.lists.length workspace_numbers
                )
              }"
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
          "zen-twilight"
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
        # plugin.dynamic-cursors = {
        #   enabled = true;
        #   mode = "stretch";
        # };
      };
      systemd.variables = [ "--all" ]; # fixed kdeconnect clipboard sync
      # plugins = [
      #   inputs.hypr-dynamic-cursors.packages.${host.system}.hypr-dynamic-cursors
      #   inputs.Hyprspace.packages.${host.system}.Hyprspace
      # ];
    };
  home.packages = with pkgs; [ hyprland-qtutils ];
  sops.secrets.location = { };
}
