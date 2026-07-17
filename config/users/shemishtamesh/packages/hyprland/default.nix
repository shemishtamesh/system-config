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
  rounding = 10;
  scripts = import ./scripts.nix {
    inherit
      pkgs
      gaps
      rounding
      host
      ;
  };
  sorted_monitors = builtins.sort (
    a: b: (host.monitors.${a}.horizontal_offset < host.monitors.${b}.horizontal_offset)
  ) (builtins.attrNames host.monitors);

  mod = "SUPER";

  toLua = lib.generators.toLua { };

  dspCall =
    path: args:
    lib.generators.mkLuaInline "hl.dsp.${path}(${lib.optionalString (args != null) (toLua args)})";

  mkBind = key: path: args: flags: {
    _args = [
      key
      (dspCall path args)
    ]
    ++ lib.optional (flags != null) flags;
  };
  mkExecBind =
    key: cmd: flags:
    mkBind key "exec_cmd" cmd flags;
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
      configType = "lua";
      settings = {
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
            {
              output = portname;
              mode = "${toString width}x${toString height}@${toString refresh_rate}";
              position = "${toString horizontal_offset}x${toString vertical_offset}";
              scale = scaling;
            }
          ) host.monitors
        );

        bind = [
          (mkBind "${mod} + CTRL + SHIFT + q" "exit" null null)

          (mkBind "${mod} + SHIFT + w" "window.close" null null)
          (mkBind "${mod} + SHIFT + q" "window.kill" null null)

          (mkBind "${mod} + c" "window.cycle_next" null null)
          (mkBind "${mod} + SHIFT + c" "window.cycle_next" { next = false; } null)

          (mkBind "${mod} + f" "window.fullscreen" { mode = "maximized"; } null)
          (mkBind "${mod} + SHIFT + f" "window.fullscreen" { mode = "fullscreen"; } null)
          (mkBind "${mod} + CTRL + f" "window.fullscreen_state" {
            internal = -1;
            client = 2;
          } null)
          (mkBind "${mod} + t" "window.float" { action = "toggle"; } null)

          (mkBind "${mod} + r" "layout" "togglesplit" null)
          (mkBind "${mod} + CTRL + r" "layout" "swapsplit" null)
          (mkBind "${mod} + SHIFT + r" "layout" "movetoroot" null)

          # (mkBind "${mod} + Tab" "overview:toggle" null null) # Hyprspace
          (mkExecBind "${mod} + Tab" "qs ipc -c overview call overview toggle" null)
          (mkExecBind "${mod} + SPACE" "noctalia-shell ipc call launcher toggle" null)
          (mkExecBind "${mod} + CTRL + c" "hyprpicker --render-inactive --autocopy" null)
          (mkExecBind "${mod} + s" "hyprshot --freeze --mode region" null)
          (mkExecBind "${mod} + SHIFT + s" "hyprshot --freeze --mode window" null)
          (mkExecBind "${mod} + CTRL + s" "hyprshot --freeze --mode output" null)
          (mkExecBind "${mod} + RETURN" "wezterm start tmux" null)
          (mkExecBind "${mod} + i" "zen-twilight" null)
          (mkExecBind "${mod} + SHIFT + i" "zen-twilight --private-window" null)
          (mkExecBind "${mod} + d" "obsidian" null)
          (mkExecBind "${mod} + SHIFT + d" "drawy" null)

          (mkExecBind "${mod} + v" "noctalia-shell ipc call launcher clipboard" null)

          (mkExecBind "${mod} + w" "killall wshowkeys || wshowkeys -a bottom" null)

          (mkExecBind "${mod} + Escape" "noctalia-shell ipc call sessionMenu toggle" null)
          (mkExecBind "${mod} + grave" "noctalia-shell ipc call sessionMenu lockAndSuspend" null)

          (mkExecBind "${mod} + a" "noctalia-shell ipc call idleInhibitor toggle" null)

          (mkExecBind "${mod} + b" scripts.toggle-bar null)

          (mkBind "${mod} + XF86Reload" "workspace.toggle_special" "chat" null)
          (mkBind "${mod} + SHIFT + XF86Reload" "window.move" { workspace = "special:chat"; } null)
          (mkBind "${mod} + XF86AudioPlay" "workspace.toggle_special" "music" null)
          (mkBind "${mod} + SHIFT + XF86AudioPlay" "window.move" { workspace = "special:music"; } null)
          (mkBind "${mod} + 0" "workspace.toggle_special" "scratchpad" null)
          (mkBind "${mod} + SHIFT + 0" "window.move" { workspace = "special:scratchpad"; } null)
          (mkBind "${mod} + e" "focus" { workspace = "emptym"; } null)
          (mkBind "${mod} + SHIFT + e" "window.move" { workspace = "emptym"; } null)
          (mkBind "${mod} + o" "focus" { workspace = "previous"; } null)

          (mkBind "${mod} + mouse_down" "focus" { workspace = "m+1"; } null)
          (mkBind "${mod} + mouse_up" "focus" { workspace = "m-1"; } null)
          (mkExecBind "${mod} + CTRL + 0"
            ''hyprctl --quiet keyword cursor:zoom_disable_aa $(echo "1 - $(hyprctl getoption cursor:zoom_disable_aa | awk '/^int.*/ {print $2}')" | ${pkgs.bc}/bin/bc)''
            null
          )
          (mkExecBind "${mod} + CTRL + mouse_down"
            "hyprctl --quiet keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor | awk '/^float.*/ {print $2 * 1.1}')"
            null
          )
          (mkExecBind "${mod} + CTRL + mouse_up"
            "hyprctl --quiet keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor | awk '/^float.*/ {new = $2 * 0.9; if (new < 1) new = 1; print new}')"
            null
          )

          (mkBind "${mod} + bracketleft" "focus" { workspace = "m-1"; } null)
          (mkBind "${mod} + SHIFT + bracketright" "window.move" { workspace = "m+1"; } null)
          (mkBind "${mod} + SHIFT + bracketleft" "window.move" { workspace = "m-1"; } null)
          (mkBind "${mod} + bracketright" "focus" { workspace = "m+1"; } null)
          (mkBind "${mod} + n" "focus" { monitor = "-1"; } null)
          (mkBind "${mod} + p" "focus" { monitor = "+1"; } null)
          (mkBind "${mod} + SHIFT + n" "window.move" { monitor = "-1"; } null)
          (mkBind "${mod} + SHIFT + p" "window.move" { monitor = "+1"; } null)
          (mkBind "${mod} + ALT + n" "workspace.move" { monitor = "-1"; } null)
          (mkBind "${mod} + ALT + p" "workspace.move" { monitor = "+1"; } null)
        ]
        ++ (builtins.concatLists (
          builtins.genList (
            i:
            let
              num = toString (i + 1);
            in
            [
              (mkBind "${mod} + ${num}" "focus" { workspace = num; } null)
              (mkBind "${mod} + SHIFT + ${num}" "window.move" { workspace = num; } null)
            ]
          ) 9
        ))
        ++ (builtins.genList (
          i:
          let
            num = toString (i + 1);
          in
          mkExecBind "${mod} + CTRL + ${num}" "hyprctl keyword cursor:zoom_factor ${num}" null
        ) 9)
        ++ [
          (mkExecBind "${mod} + semicolon" "noctalia-shell ipc call notifications dismissOldest" {
            repeating = true;
          })
          (mkExecBind "${mod} + SHIFT + semicolon" "noctalia-shell ipc call notifications dismissAll" {
            repeating = true;
          })
          (mkExecBind "${mod} + CTRL + semicolon" "noctalia-shell ipc call notifications toggleHistory" {
            repeating = true;
          })
          (mkExecBind "${mod} + ALT + semicolon" "noctalia-shell ipc call notifications toggleDND" {
            repeating = true;
          })

          (mkBind "${mod} + h" "focus" { direction = "l"; } { repeating = true; })
          (mkBind "${mod} + j" "focus" { direction = "d"; } { repeating = true; })
          (mkBind "${mod} + k" "focus" { direction = "u"; } { repeating = true; })
          (mkBind "${mod} + l" "focus" { direction = "r"; } { repeating = true; })
          (mkBind "${mod} + SHIFT + h" "window.swap" { direction = "l"; } { repeating = true; })
          (mkBind "${mod} + SHIFT + j" "window.swap" { direction = "d"; } { repeating = true; })
          (mkBind "${mod} + SHIFT + k" "window.swap" { direction = "u"; } { repeating = true; })
          (mkBind "${mod} + SHIFT + l" "window.swap" { direction = "r"; } { repeating = true; })
          (mkBind "${mod} + CTRL + h" "window.move" { direction = "l"; } { repeating = true; })
          (mkBind "${mod} + CTRL + j" "window.move" { direction = "d"; } { repeating = true; })
          (mkBind "${mod} + CTRL + k" "window.move" { direction = "u"; } { repeating = true; })
          (mkBind "${mod} + CTRL + l" "window.move" { direction = "r"; } { repeating = true; })
          (mkBind "${mod} + ALT + h" "window.resize" {
            x = -10;
            y = 0;
            relative = true;
          } { repeating = true; })
          (mkBind "${mod} + ALT + j" "window.resize" {
            x = 0;
            y = 10;
            relative = true;
          } { repeating = true; })
          (mkBind "${mod} + ALT + k" "window.resize" {
            x = 0;
            y = -10;
            relative = true;
          } { repeating = true; })
          (mkBind "${mod} + ALT + l" "window.resize" {
            x = 10;
            y = 0;
            relative = true;
          } { repeating = true; })
          (mkBind "${mod} + ALT + SHIFT + h" "window.resize" {
            x = -1;
            y = 0;
            relative = true;
          } { repeating = true; })
          (mkBind "${mod} + ALT + SHIFT + j" "window.resize" {
            x = 0;
            y = 1;
            relative = true;
          } { repeating = true; })
          (mkBind "${mod} + ALT + SHIFT + k" "window.resize" {
            x = 0;
            y = -1;
            relative = true;
          } { repeating = true; })
          (mkBind "${mod} + ALT + SHIFT + l" "window.resize" {
            x = 1;
            y = 0;
            relative = true;
          } { repeating = true; })

          (mkExecBind "XF86AudioRaiseVolume" "wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+" {
            repeating = true;
          })
          (mkExecBind "XF86AudioLowerVolume" "wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-" {
            repeating = true;
          })
          (mkExecBind "SHIFT + XF86AudioRaiseVolume" "wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%+" {
            repeating = true;
          })
          (mkExecBind "SHIFT + XF86AudioLowerVolume" "wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%-" {
            repeating = true;
          })

          (mkExecBind "CTRL + XF86AudioRaiseVolume" "wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 1%+" {
            repeating = true;
          })
          (mkExecBind "CTRL + XF86AudioLowerVolume" "wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 1%-" {
            repeating = true;
          })
          (mkExecBind "CTRL + SHIFT + XF86AudioRaiseVolume" "wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 10%+" {
            repeating = true;
          })
          (mkExecBind "CTRL + SHIFT + XF86AudioLowerVolume" "wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 10%-" {
            repeating = true;
          })
          (mkExecBind "ALT + XF86AudioRaiseVolume" "wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 100%" {
            repeating = true;
          })
          (mkExecBind "ALT + XF86AudioLowerVolume" "wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 30%" {
            repeating = true;
          })

          (mkExecBind "XF86Reload" "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle" {
            locked = true;
            release = true;
          })

          (mkExecBind "CTRL + XF86Reload" "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle" { locked = true; })
          (mkExecBind "XF86Reload" "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle" { locked = true; })
          (mkExecBind "XF86AudioMute" "wpctl set-mute @DEFAULT_SINK@ toggle" { locked = true; })

          (mkExecBind "XF86AudioPlay" "${pkgs.playerctl}/bin/playerctl play-pause" { locked = true; })
          (mkExecBind "XF86AudioPrev" "${pkgs.playerctl}/bin/playerctl previous" { locked = true; })
          (mkExecBind "XF86AudioNext" "${pkgs.playerctl}/bin/playerctl next" { locked = true; })

          (mkExecBind "XF86MonBrightnessUp" ''${shared.scripts.set_brightness} "+ 1"'' {
            locked = true;
            repeating = true;
          })
          (mkExecBind "XF86MonBrightnessDown" ''${shared.scripts.set_brightness} "- 1"'' {
            locked = true;
            repeating = true;
          })
          (mkExecBind "SHIFT + XF86MonBrightnessUp" ''${shared.scripts.set_brightness} "+ 10"'' {
            locked = true;
            repeating = true;
          })
          (mkExecBind "SHIFT + XF86MonBrightnessDown" ''${shared.scripts.set_brightness} "- 10"'' {
            locked = true;
            repeating = true;
          })
          (mkExecBind "CTRL + XF86MonBrightnessUp" ''${shared.scripts.set_brightness} "100"'' {
            locked = true;
            repeating = true;
          })
          (mkExecBind "CTRL + XF86MonBrightnessDown" ''${shared.scripts.set_brightness} "0"'' {
            locked = true;
            repeating = true;
          })

          (mkBind "${mod} + mouse:272" "window.drag" null { mouse = true; })
          (mkBind "${mod} + mouse:273" "window.resize" null { mouse = true; })
        ];

        config = {
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

            snap.enabled = true;

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
          decoration = {
            inherit rounding;
            shadow = {
              enabled = true;
              range = 20;
            };
          };
          dwindle.preserve_split = true;
          misc = {
            force_default_wallpaper = 1;
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
          };
          # plugin."dynamic-cursors" = {
          #   enabled = true;
          #   mode = "stretch";
          # };
        };

        permission = [
          {
            binary = "${pkgs.hyprlock}/bin/hyprlock";
            type = "screencopy";
            mode = "allow";
          }
          {
            binary = "${pkgs.grim}/bin/grim";
            type = "screencopy";
            mode = "allow";
          }
        ];

        curve = [
          {
            _args = [
              "wind"
              {
                type = "bezier";
                points = [
                  [
                    0.05
                    0.9
                  ]
                  [
                    0.1
                    1.05
                  ]
                ];
              }
            ];
          }
          {
            _args = [
              "winIn"
              {
                type = "bezier";
                points = [
                  [
                    0.1
                    1.1
                  ]
                  [
                    0.1
                    1.1
                  ]
                ];
              }
            ];
          }
          {
            _args = [
              "winOut"
              {
                type = "bezier";
                points = [
                  [
                    0.3
                    (-0.3)
                  ]
                  [
                    0
                    1
                  ]
                ];
              }
            ];
          }
          {
            _args = [
              "linear"
              {
                type = "bezier";
                points = [
                  [
                    1
                    1
                  ]
                  [
                    1
                    1
                  ]
                ];
              }
            ];
          }
        ];
        animation = [
          {
            leaf = "windows";
            enabled = true;
            speed = 6;
            bezier = "wind";
            style = "slide";
          }
          {
            leaf = "windowsIn";
            enabled = true;
            speed = 6;
            bezier = "winIn";
            style = "slide";
          }
          {
            leaf = "windowsOut";
            enabled = true;
            speed = 6;
            bezier = "winOut";
            style = "slide";
          }
          {
            leaf = "windowsMove";
            enabled = true;
            speed = 6;
            bezier = "wind";
            style = "slide";
          }
          {
            leaf = "fade";
            enabled = true;
            speed = 5;
            bezier = "linear";
          }
          {
            leaf = "fadeIn";
            enabled = true;
            speed = 1;
            bezier = "linear";
          }
          {
            leaf = "fadeOut";
            enabled = true;
            speed = 10;
            bezier = "linear";
          }
          {
            leaf = "workspaces";
            enabled = true;
            speed = 5;
            bezier = "wind";
          }
          {
            leaf = "specialWorkspace";
            enabled = true;
            speed = 5;
            bezier = "wind";
            style = "slidevert";
          }
          {
            leaf = "fadeSwitch";
            enabled = true;
            speed = 2;
            bezier = "linear";
          }
        ];

        layer_rule = {
          match.namespace = "quickshell";
          no_anim = true;
        };
        window_rule = [
          # open aseprite in tiled mode by default
          {
            match.class = "Aseprite";
            tile = true;
          }

          # move specific apps to their special workspaces
          {
            match.initial_class = "(?i)^(spotify)$";
            workspace = "special:music silent";
          }
          {
            match.initial_class = "(?i)^(discord|vesktop|altus|slack)$";
            workspace = "special:chat silent";
          }

          # floating window appearance
          {
            match.float = true;
            no_shadow = false;
          }

          # special workspace appearance
          {
            match.workspace = "s[true]";
            opacity = "0.95 0.8";
            rounding = 20;
          }
        ];
        workspace_rule = [
          # no borders/gaps when there's only a single visible window
          {
            workspace = "w[v1]";
            no_rounding = true;
            no_border = true;
            gaps_out = 0;
            gaps_in = 0;
          }
          {
            workspace = "f[1]";
            gaps_out = 0;
            gaps_in = 0;
          }

          # special workspace appearance
          {
            workspace = "s[true]";
            gaps_in = 15;
            gaps_out = 20;
            border_size = 0;
            no_border = true;
            no_shadow = false;
          }
          {
            workspace = "s[false]";
            no_shadow = true;
          }
        ]
        ++ (
          (
            monitor_portnames: workspace_numbers:
            lib.lists.imap0 (i: key: {
              workspace = toString key;
              monitor = lib.lists.elemAt monitor_portnames (
                i * lib.lists.length monitor_portnames / lib.lists.length workspace_numbers
              );
            }) workspace_numbers
          )
          sorted_monitors
          (lib.range 1 9)
        );

        device = {
          name = "wacom-one-by-wacom-s-pen";
          output = builtins.elemAt sorted_monitors (builtins.length sorted_monitors / 2);
          left_handed = true;
        };

        exec_cmd = [
          "zen-twilight"
          "spotify"
          "discord"
          "altus"
          "slack"
          "wl-paste --watch cliphist store"
          "${scripts.notification-log} $HOME/Documents/logs/notifications.txt"
          "${pkgs.playerctl}/bin/playerctld"
          "kdeconnect-indicator"
          "hypridle"
          "${pkgs.hypridle}/bin/hypridle"
          "transmission-daemon"
          "${pkgs.easyeffects}/bin/easyeffects --gapplication-service"
          "noctalia-shell"
          "qs -c overview"
        ];
      };
      systemd.variables = [ "--all" ]; # fixed kdeconnect clipboard sync
      plugins = [
        # inputs.hypr-dynamic-cursors.packages.${host.system}.hypr-dynamic-cursors
      ];
    };
  home.packages = with pkgs; [ hyprland-qtutils ];
}
