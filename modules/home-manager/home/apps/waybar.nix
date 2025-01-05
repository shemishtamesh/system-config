{
  config,
  pkgs,
  ...
}:
let
  palette = config.lib.stylix.colors.withHashtag;
  rgba = (import ../../../general/utils.nix { inherit pkgs; }).rgba config.lib.stylix.colors;
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
        output = [
          "eDP-1"
          "HDMI-A-1"
        ];
        modules-left = [ "hyprland/window" ];
        modules-center = [ "hyprland/workspaces" ];
        modules-right = [ "mpris" ];

        "hyprland/workspaces" = {
          format = "{icon} {windows}";
          format-window-separator = " ";
          window-rewrite-default = window_icon;
          window-rewrite = {
            "class<(firefox|librewolf|zen-alpha)> title<.*youtube.*>" = "";
            "class<(firefox|librewolf|zen-alpha)> title<.*github.*>" = "";
            "class<(firefox|librewolf|zen-alpha)>" = firefox_icon;
            "class<spotify>" = spotify_icon;
            "class<.*discord.*>" = "";
            "class<kitty>" = "";
            "code" = "󰨞";
          };
          show-special = true;
          special-visible-only = true;
        };
        "hyprland/window" = {
          icon = true;
          icon-size = 18;
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

      taskbar = {
        position = "right";
        output = [
          "eDP-1"
        ];
        modules-center = [
          "disk"
          "backlight"
          "pulseaudio#output"
          "pulseaudio#input"
          "hyprland/language"
          "memory"
          "cpu"
          "temperature"
          "privacy"
          "network"
          "bluetooth"
          "user"
          "battery"
        ];

        cpu = {
          format = " {usage}%";
          justify = "center";
          rotate = 270;
        };
        memory = {
          format = " {percentage}%";
          justify = "center";
          rotate = 270;
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
          justify = "center";
          rotate = 270;
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
            rotate = 270;
          };
          scroll-step = 2;
          smooth-scrolling-threshold = 1;
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          on-click-middle = "pavucontrol";
          justify = "center";
          rotate = 270;
        };
        backlight = {
          format = " {percent}%";
          on-scroll-up = "brightnessctl set +10%";
          on-scroll-down = "brightnessctl set 10%-";
          justify = "center";
          rotate = 270;
        };
        battery = {
          format = " {capacity}%";
          justify = "center";
          rotate = 270;
        };
        temperature = {
          thermal-zone = 6;
          rotate = 270;
        };
        network = {
          format = " {essid} {signalStrength}%";
          format-disconnected = "󰖪";
          justify = "center";
          rotate = 270;
        };
        bluetooth = {
          justify = "center";
          rotate = 270;
        };
        "hyprland/language" = {
          format = " {language}";
          justify = "center";
          rotate = 270;
        };
        user = {
          format = " {work_d} days, {work_H}:{work_M}";
          justify = "center";
          rotate = 270;
        };
        disk = {
          format = " {percentage_free}%";
          justify = "center";
          rotate = 270;
        };
      };

      bottom_bar = {
        position = "bottom";
        output = [
          "eDP-1"
          "HDMI-A-1"
        ];
        modules-left = [ "clock" ];
        modules-center = [
          "wlr/taskbar"
        ];
        modules-right = [
          "tray"
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
          format = "{icon} {title}";
          icon-size = 14;
          icon-theme = "Numix-Circle";
          tooltip-format = "{title}";
          on-click = "activate";
          on-click-middle = "close";
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "󰛊";
            deactivated = "󰾫";
          };
        };
      };
    };
    style = # css
      ''
        * {
            border: none;
            border-radius: 0;
            min-height: 0;
            font-family: FiraCode Nerd Font;
            font-weight: bold;
            font-size: 15px;
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
        #workspaces button,
        #battery {
            background: ${palette.base0C};
            color: ${palette.base00};
            opacity: 1;
            padding: 2px 1px;
            margin: 4 0px;
            border-radius: 10px;
            animation: gradient_f 20s ease-in infinite;
            transition: all 0.3s cubic-bezier(0.55, -0.68, 0.48, 1.682);
        }

        #clock,
        #idle_inhibitor,
        #tray,
        #window,
        #workspaces button,
        #mpris {
            background: ${palette.base0C};
            color: ${palette.base00};
            opacity: 1;
            padding: 1px 2px;
            margin: 0 4px;
            border-radius: 10px;
            animation: gradient_f 20s ease-in infinite;
            transition: all 0.3s cubic-bezier(0.55, -0.68, 0.48, 1.682);
        }

        #idle_inhibitor.activated,
        #pulseaudio.input,
        #pulseaudio.output.muted,
        #network.disconnected,
        #privacy {
            background: ${palette.base08};
            color: ${palette.base07};
            padding: 12px 1px 11px 1px;
        }

        #network.disconnected,
        #idle_inhibitor {
            padding: 1px 8px 1px 5px;
        }

        #workspaces {
            background: ${rgba "base00" 0};
        }
        #workspaces button {
            padding: 1px 10px 1px 5px;
        }
        #workspaces button:hover {
            padding: 1px 12px 1px 7px;
            background: ${palette.base0D};
            margin-bottom: 0;
        }
        #workspaces button.active {
            padding: 1px 15px 1px 10px;
            background: ${palette.base0B};
        }

        window#waybar.empty #window {
            padding: 1px 50px;
            background: ${palette.base02};
        }

        #mpris.paused {
            background: ${palette.base02};
            color: ${palette.base05};
        }
        #mpris.playing {
            padding: 1px 3px;
        }
      '';
  };
}
