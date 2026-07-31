{
  lib,
  pkgs,
  host,
  config,
  inputs,
  ...
}:
let
  gaps = 5;
  rounding = 10;
  scripts = import ./scripts.nix { inherit pkgs; };
  sorted_monitors = builtins.sort (
    a: b: (host.monitors.${a}.horizontal_offset < host.monitors.${b}.horizontal_offset)
  ) (builtins.attrNames host.monitors);

  mod = "SUPER";
  # $mod+CTRL+1..9 sets a fixed zoom level, linear from 1x (at 1) to maxZoom (at 9)
  maxZoom = 4.0;

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

  mkFnBind = key: body: flags: {
    _args = [
      key
      (lib.generators.mkLuaInline "function()\n${body}\nend")
    ]
    ++ lib.optional (flags != null) flags;
  };

  mkStartupHook = commands: {
    _args = [
      "hyprland.start"
      (lib.generators.mkLuaInline "function()\n${
        lib.concatMapStrings (cmd: "  hl.exec_cmd(${toLua cmd})\n") commands
      }end")
    ];
  };
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
            internal = 0;
            client = 2;
            action = "toggle";
          } null)
          (mkBind "${mod} + t" "window.float" { action = "toggle"; } null)

          (mkBind "${mod} + r" "layout" "togglesplit" null)
          (mkBind "${mod} + CTRL + r" "layout" "swapsplit" null)
          (mkBind "${mod} + SHIFT + r" "layout" "movetoroot" null)

          (mkExecBind "${mod} + Tab" "noctalia msg window-switcher" null)
          (mkExecBind "${mod} + CTRL + Tab" "qs ipc -c overview call overview toggle" null)
          (mkExecBind "${mod} + SPACE" "noctalia msg panel-toggle launcher" null)
          (mkExecBind "${mod} + CTRL + c" "hyprpicker --render-inactive --autocopy" null)
          (mkExecBind "${mod} + s" "noctalia msg screenshot-region" null)
          (mkExecBind "${mod} + SHIFT + s" "noctalia msg screenshot-fullscreen" null)
          (mkExecBind "${mod} + CTRL + s" "noctalia msg plugin noctalia/screen_recorder:service all toggle"
            null
          )
          (mkExecBind "${mod} + RETURN" "wezterm start tmux" null)
          (mkExecBind "${mod} + i" "zen-twilight" null)
          (mkExecBind "${mod} + SHIFT + i" "zen-twilight --private-window" null)
          (mkExecBind "${mod} + d" "obsidian" null)
          (mkExecBind "${mod} + SHIFT + d" "drawy" null)

          (mkExecBind "${mod} + v" "noctalia msg panel-toggle clipboard" null)

          (mkExecBind "${mod} + w" "killall wshowkeys || wshowkeys -a bottom" null)

          (mkExecBind "${mod} + Escape" "noctalia msg panel-toggle session" null)
          (mkExecBind "${mod} + grave" "noctalia msg session lock-and-suspend" null)

          (mkExecBind "${mod} + a" "noctalia msg caffeine-toggle" null)

          (mkFnBind "${mod} + b" /* lua */ ''
            if hl.get_config("general.border_size") == 1 then
              hl.config({
                general = { border_size = 0, gaps_in = 0, gaps_out = 0 },
                decoration = { rounding = 0, shadow = { enabled = true, range = 50 } },
              })
            else
              hl.config({
                general = { border_size = 1, gaps_in = ${toString gaps}, gaps_out = ${toString gaps} },
                decoration = { rounding = ${toString rounding}, shadow = { enabled = true, range = 10 } },
              })
            end
          '' null)

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
          (mkFnBind "${mod} + CTRL + 0" /* lua */ ''
            local disabled = hl.get_config("cursor.zoom_disable_aa")
            hl.config({ cursor = { zoom_disable_aa = not disabled } })
          '' null)
          (mkFnBind "${mod} + CTRL + mouse_down" /* lua */ ''
            local factor = hl.get_config("cursor.zoom_factor")
            hl.config({ cursor = { zoom_factor = factor * 1.1 } })
          '' null)
          (mkFnBind "${mod} + CTRL + mouse_up" /* lua */ ''
            local factor = hl.get_config("cursor.zoom_factor")
            local new_factor = factor * 0.9
            if new_factor < 1 then new_factor = 1 end
            hl.config({ cursor = { zoom_factor = new_factor } })
          '' null)

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
            # linear interpolation: i=0..8 (9 keys) over 8 gaps, from 1x to maxZoom
            zoomFactor = toString (1.0 + i * (maxZoom - 1.0) / 8.0);
          in
          mkFnBind "${mod} + CTRL + ${num}" /* lua */ ''
            hl.config({ cursor = { zoom_factor = ${zoomFactor} } })
          '' null
        ) 9)
        ++ [
          (mkExecBind "${mod} + semicolon" "noctalia msg notification-clear-active" {
            repeating = true;
          })
          (mkExecBind "${mod} + SHIFT + semicolon" "noctalia msg notification-clear-history" {
            repeating = true;
          })
          (mkExecBind "${mod} + CTRL + semicolon" "noctalia msg panel-toggle control-center notifications" {
            repeating = true;
          })
          (mkExecBind "${mod} + ALT + semicolon" "noctalia msg notification-dnd-toggle" {
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

          (mkExecBind "XF86AudioRaiseVolume" "noctalia msg volume-up 1%" {
            repeating = true;
          })
          (mkExecBind "XF86AudioLowerVolume" "noctalia msg volume-down 1%" {
            repeating = true;
          })
          (mkExecBind "SHIFT + XF86AudioRaiseVolume" "noctalia msg volume-up 10%" {
            repeating = true;
          })
          (mkExecBind "SHIFT + XF86AudioLowerVolume" "noctalia msg volume-down 10%" {
            repeating = true;
          })

          (mkExecBind "CTRL + XF86AudioRaiseVolume" "noctalia msg mic-volume-up 1%" {
            repeating = true;
          })
          (mkExecBind "CTRL + XF86AudioLowerVolume" "noctalia msg mic-volume-down 1%" {
            repeating = true;
          })
          (mkExecBind "CTRL + SHIFT + XF86AudioRaiseVolume" "noctalia msg mic-volume-up 10%" {
            repeating = true;
          })
          (mkExecBind "CTRL + SHIFT + XF86AudioLowerVolume" "noctalia msg mic-volume-down 10%" {
            repeating = true;
          })
          (mkExecBind "ALT + XF86AudioRaiseVolume" "playerctl position 5+" { repeating = true; })
          (mkExecBind "ALT + XF86AudioLowerVolume" "playerctl position 5-" { repeating = true; })
          (mkExecBind "CTRL + ALT + XF86AudioRaiseVolume" "noctalia msg media next-player" {
            repeating = true;
          })
          (mkExecBind "CTRL + ALT + XF86AudioLowerVolume" "noctalia msg media previous-player" {
            repeating = true;
          })

          (mkExecBind "XF86Reload" "noctalia msg mic-mute" {
            locked = true;
            release = true;
          })

          (mkExecBind "CTRL + XF86Reload" "noctalia msg mic-mute" { locked = true; })
          (mkExecBind "XF86Reload" "noctalia msg mic-mute" { locked = true; })
          (mkExecBind "XF86AudioMute" "noctalia msg volume-mute" { locked = true; })

          (mkExecBind "XF86AudioPlay" "noctalia msg media toggle" { locked = true; })
          (mkExecBind "XF86AudioPrev" "noctalia msg media previous" { locked = true; })
          (mkExecBind "XF86AudioNext" "noctalia msg media next" { locked = true; })

          (mkExecBind "XF86MonBrightnessUp" "noctalia msg brightness-up current 1%" {
            locked = true;
            repeating = true;
          })
          (mkExecBind "XF86MonBrightnessDown" "noctalia msg brightness-down current 1%" {
            locked = true;
            repeating = true;
          })
          (mkExecBind "SHIFT + XF86MonBrightnessUp" "noctalia msg brightness-up current 10%" {
            locked = true;
            repeating = true;
          })
          (mkExecBind "SHIFT + XF86MonBrightnessDown" "noctalia msg brightness-down current 10%" {
            locked = true;
            repeating = true;
          })
          (mkExecBind "CTRL + XF86MonBrightnessUp" "noctalia msg brightness-set current 100%" {
            locked = true;
            repeating = true;
          })
          (mkExecBind "CTRL + XF86MonBrightnessDown" "noctalia msg brightness-set current 0%" {
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
              range = 10;
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
            opacity = "1.0 0.85";
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
            no_shadow = false;
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

        on = mkStartupHook [
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
          "noctalia"
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
