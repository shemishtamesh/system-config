{
  pkgs,
  config,
  shared,
  host,
  ...
}:
let
  palette = config.lib.stylix.colors.withHashtag;
  rgba = shared.functions.rgba config.lib.stylix.colors;
  window_icon = "";
  firefox_icon = "󰈹";
  spotify_icon = "";
in
{
  stylix.targets.waybar.enable = false;
  programs.waybar = {
    enable = true;
    settings = {
      top_bar = {
        position = "top";
        output = builtins.attrNames host.monitors;
        modules-left = [ "hyprland/window" ];
        modules-center = [ "hyprland/workspaces" ];
        modules-right = [ "mpris" ];

        "hyprland/workspaces" = {
          format = "{icon} {windows}";
          format-window-separator = " ";
          window-rewrite-default = window_icon;
          window-rewrite = {
            "class<(firefox|librewolf|zen-(alpha|twilight))> title<.*youtube.*>" = "";
            "class<(firefox|librewolf|zen-(alpha|twilight))> title<.*jira.*>" = "󰌃";
            "class<(firefox|librewolf|zen-(alpha|twilight))> title<.*github.*>" = "";
            "class<(firefox|librewolf|zen-(alpha|twilight))>" = firefox_icon;
            "class<spotify>" = spotify_icon;
            "class<.*discord.*>" = "";
            "class<kitty>" = "";
            "(whatsapp|Altus)" = "󰖣";
            "slack" = "󰒱";
            "code" = "󰨞";
          };
          show-special = true;
          special-visible-only = true;
        };
        "hyprland/window" = {
          icon = true;
          icon-size = 18;
          separate-outputs = true;
        };
        mpris = {
          format = "{player_icon}{status_icon}: {dynamic}";
          dynamic-separator = " | ";
          tooltip-format = "{player} {status} {artist}'s {title} from {album} at {position} out of {length}";
          title-len = 25;
          artist-len = 20;
          album-len = 20;
          player-icons = {
            default = "${window_icon} ";
            mpv = " ";
            firefox = "${firefox_icon} ";
            librewolf = "${firefox_icon} ";
            zen = "${firefox_icon} ";
            spotify = "${spotify_icon} ";
          };
          status-icons = {
            default = "";
            paused = "";
          };
          interval = 1;
        };
      };

      bottom_bar = {
        position = "bottom";
        output = builtins.attrNames host.monitors;
        modules-left = [ "clock" ];
        modules-center = [
          "disk"
          "backlight"
          "pulseaudio#output"
          "pulseaudio#input"
          "hyprland/language"
          "keyboard-state"
          "memory"
          "cpu"
          "temperature"
          "privacy"
          "network"
          "bluetooth"
          "user"
          "battery"
        ];
        modules-right = [
          "tray"
          "custom/dunst"
          "custom/dasdfunst"
          "idle_inhibitor"
        ];

        clock = {
          format = "{:%A %B %d, %Y, %R}";
          format-alt = "{:%Y/%m/%d %H:%M}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months = "<span color='${palette.base0A}'><b>{}</b></span>";
              days = "<span color='${palette.base0C}'><b>{}</b></span>";
              weeks = "<span color='${palette.base0B}'><b>{}</b></span>";
              weekdays = "<span color='${palette.base09}'><b>{}</b></span>";
              today = "<span color='${palette.base08}'><b>{}</b></span>";
            };
          };
          actions = {
            on-click-right = "mode";
            on-click-middle = "shift_reset";
            on-scroll-up = "shift_down";
            on-scroll-down = "shift_up";
          };
        };
        "wlr/taskbar" = {
          format = "{icon} {title:.10}";
          icon-size = 14;
          icon-theme = "Numix-Circle";
          tooltip-format = "{app_id} ({state}): {name}";
          on-click = "activate";
          on-click-middle = "close";
          on-click-right = "maximize";
        };
        dunst = {
          exec = # sh
            ''
              # echo "{\"class\":\"$(${pkgs.dunst}/bin/dunstctl is-paused)\"}"
              echo "test"
            '';
          # return-type = "json";
          # format = "󰍥";
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "󰛊";
            deactivated = "󰾫";
          };
        };
        cpu = {
          format = " {usage}%";
        };
        memory = {
          format = " {percentage}%";
        };
        "pulseaudio#input" = {
          format-source = " {volume}%";
          format-source-muted = " ";
          format = "{format_source}";
          scroll-step = 1;
          smooth-scrolling-threshold = 1;
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
          on-click-middle = "pavucontrol";
          on-scroll-up = "wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 1%+";
          on-scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 1%-";
        };
        "pulseaudio#output" = {
          format = "{icon} {volume}%";
          format-muted = "";
          format-icons = {
            default = [
              ""
              ""
              ""
            ];
          };
          scroll-step = 2;
          smooth-scrolling-threshold = 1;
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          on-click-middle = "pavucontrol";
        };
        backlight = {
          format = " {percent}%";
          on-scroll-up = "brightnessctl set +10%";
          on-scroll-down = "brightnessctl set 10%-";
        };
        battery = {
          format = " {capacity}%";
        };
        temperature = {
          thermal-zone = 0;
        };
        network = {
          format = " {essid} {signalStrength}%";
          format-disconnected = "󰖪";
        };
        bluetooth = {
        };
        "hyprland/language" = {
          format = " {}";
          format-en = "🇺🇸";
          format-he = "🇮🇱";
        };
        keyboard-state = {
          numlock = true;
          capslock = true;
          scrolllock = true;
          format = {
            scrolllock = " {icon}, ";
            capslock = "󰪛 {icon}, ";
            numlock = "# {icon}";
          };
          format-icons = {
            locked = " ";
            unlocked = " ";
          };
        };
        user = {
          format = " {work_d} days, {work_H}:{work_M}";
        };
        disk = {
          format = " {percentage_free}%";
        };
      };
    };
    style = # css
      ''
        * {
            border: none;
            border-radius: 10px;
            min-height: 0px;
            font-family: FiraCode Nerd Font;
            font-weight: bold;
            font-size: 15px;
            animation: gradient_f 20s ease-in infinite;
            transition: all 0.3s cubic-bezier(0.55, -0.68, 0.48, 1.682);
        }

        window#waybar {
            background: ${rgba "base00" 0};
            color: ${palette.base00};
        }

        #disk,
        #cpu,
        #memory,
        #network,
        #bluetooth,
        #user,
        #temperature,
        #pulseaudio,
        #pulseaudio.input.source-muted,
        #backlight,
        #privacy,
        #language,
        #keyboard-state,
        #battery,
        #clock,
        #taskbar button,
        #workspaces button,
        #tray,
        #window,
        #mpris,
        #idle_inhibitor {
            background: ${palette.base02};
            color: ${palette.base00};
            opacity: 1;
            padding: 1px 2px;
            margin: 0px 4px;
            border-radius: 10px;
            animation: gradient_f 20s ease-in infinite;
            transition: all 0.3s cubic-bezier(0.55, -0.68, 0.48, 1.682);
        }

        #idle_inhibitor {
            padding: 1px 8px 1px 5px;
        }

        #pulseaudio.input,
        #pulseaudio.output.muted,
        #network.disconnected,
        #idle_inhibitor.activated,
        #privacy {
            background: ${palette.base08};
            color: ${palette.base07};
            padding: 1px 12px 1px 11px;
        }

        #taskbar,
        #workspaces {
            background: ${rgba "base00" 0};
        }

        #workspaces button.hover {
            padding: 1px 12px 1px 7px;
            background: ${palette.base02};
            margin-bottom: 0px;
        }

        #taskbar button,
        #workspaces button {
            padding: 1px 10px 1px 5px;
        }

        #taskbar button.active,
        #workspaces button.active {
            padding: 1px 15px 1px 10px;
            background: ${palette.base0B};
            color: ${palette.base00};
        }

        #taskbar button.maximized {
            padding: 1px 15px 1px 10px;
            background: ${palette.base05};
            color: ${palette.base00};
        }

        #taskbar button.active.maximized {
            padding: 1px 15px 1px 10px;
            background: ${palette.base13};
        }

        #taskbar.empty,
        window#waybar.empty #window {
            padding: 1px 50px;
            background: ${palette.base01};
        }

        #mpris.paused {
            background: ${palette.base01};
            color: ${palette.base02};
        }
        #mpris.playing {
            padding: 1px 3px;
        }
      '';
  };
}
