{
  inputs,
  host,
  pkgs,
  ...
}:
{
  imports = [
    inputs.noctalia.homeModules.default
  ];
  programs.noctalia-shell = {
    enable = true;
    package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
      calendarSupport = true;
    };
    settings = {
      settingsVersion = 0;
      general = {
        showHibernateOnLockScreen = true;
        enableShadows = false;
        passwordChars = true;
        lockScreenAnimations = true;
      };
      bar = {
        density = "compact";
        outerCorners = false;
        enableExclusionZoneInset = false;

        mouseWheelAction = "workspace";
        mouseWheelWrap = true;
        middleClickAction = "settings";
        middleClickFollowMouse = true;

        widgets = {
          left = [
            { id = "plugin:timer"; }
            { id = "Clock"; }
            { id = "SystemMonitor"; }
            {
              id = "WiFi";
              displayMode = "alwaysShow";
            }
            {
              id = "Bluetooth";
              displayMode = "alwaysShow";
            }
            { id = "ActiveWindow"; }
            { id = "MediaMini"; }
          ];
          center = [
            {
              id = "CustomButton";
              textCommand = /* sh */ ''
                hyprctl monitors -j | ${pkgs.jq}/bin/jq -r '
                  .[]
                  | select(.focused)
                  | if .specialWorkspace.name != "" then
                        (.specialWorkspace.name | sub("^special:";""))
                    else
                      ""
                    end
                '
              '';
              showIcon = false;
              textStream = true;
              hideMode = "expandWithOutput";
              textCollapse = "";
              textIntervalMs = 1000;
            }
            {
              id = "Workspace";
              showApplications = true;
            }
          ];
          right = [
            { id = "Tray"; }
            { id = "plugin:privacy-indicator"; }
            {
              id = "Microphone";
              displayMode = "alwaysShow";
            }
            {
              id = "Volume";
              displayMode = "alwaysShow";
            }
            {
              id = "Brightness";
              displayMode = "alwaysShow";
              applyToAllMonitors = true;
            }
            {
              id = "KeyboardLayout";
              displayMode = "forceOpen";
            }
            {
              id = "NotificationHistory";
              hideWhenZero = false;
            }
            { id = "KeepAwake"; }
            {
              id = "ControlCenter";
              useDistroLogo = true;
              enableColorization = true;
              colorizeSystemIcon = "primary";
            }
          ];
        };
      };
      controlCenter = {
        cards =
          map
            (name: {
              id = name;
              enabled = true;
            })
            [
              "profile-card"
              "shortcuts-card"
              "audio-card"
              "brightness-card"
              "weather-card"
              "media-sysmon-card"
            ];
        shortcuts = {
          left = [
            { id = "Bluetooth"; }
            { id = "WiFi"; }
            { id = "AirplaneMode"; }
            { id = "plugin:screen-recorder"; }
            {
              id = "CustomButton";
              icon = "rocket";
              leftClickExec = "noctalia-shell ipc call launcher toggle";
            }
          ];
          right = [
            {
              id = "Notifications";
            }
            {
              id = "PowerProfile";
            }
            {
              id = "NoctaliaPerformance";
            }
            {
              id = "KeepAwake";
            }
            {
              id = "NightLight";
            }
          ];
        };
      };
      dock = {
        floatingRatio = 0;
        size = 2;
        animationSpeed = 2;
        dockType = "attached";
        showLauncherIcon = true;
        pinnedStatic = true;
      };
      sessionMenu.largeButtonsStyle = true;
      osd.location = "bottom";
      notifications.location = "top_center";
      location.showWeekNumberInCalendar = true;
      wallpaper = {
        enabled = true;
        wallpapers = builtins.mapAttrs (portname: _: {
          name = portname;
          value = "~/Pictures/Wallpapers/${portname}.png";
        }) host.monitors;
        transitionType = "fade";
      };
      appLauncher = {
        enableClipboardHistory = true;
        enableClipPreview = true;
        position = "bottom_center";
        terminalCommand = "wezterm -e";
      };
      brightness = {
        enforceMinimum = false;
        enableDdcSupport = true;
      };
      desktopWidgets = {
        enabled = true;
        gridSnap = true;
      };
    };
    ui.scrollbarAlwaysVisible = false;
    systemd.enable = true;
    plugins = {
      states =
        let
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        in
        {
          translator = {
            enabled = true;
            inherit sourceUrl;
          };
          timer = {
            enabled = true;
            inherit sourceUrl;
          };
          unicode-picker = {
            enabled = true;
            inherit sourceUrl;
          };
          privacy-indicator = {
            enabled = true;
            inherit sourceUrl;
          };
          screen-recorder = {
            enabled = true;
            inherit sourceUrl;
          };
        };
    };
    pluginSettings = {
      privacy-indicator.hideInactive = true;
      screen-recorder.copyToClipboard = true;
    };
  };
  home.packages = with pkgs; [ gpu-screen-recorder ];
}
