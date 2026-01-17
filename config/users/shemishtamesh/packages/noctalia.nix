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
    package = inputs.noctalia.packages.${host.system}.default.override {
      calendarSupport = true;
    };
    settings = {
      settingsVersion = 0;
      general = {
        showHibernateOnLockScreen = true;
        enableShadows = false;
      };
      bar = {
        density = "compact";
        outerCorners = false;
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
              id = "Workspace";
              showApplications = true;
            }
          ];
          right = [
            { id = "Tray"; }
            { id = "plugin:privacy_indicator"; }
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
        cards = [
          {
            id = "profile-card";
            enabled = true;
          }
          {
            id = "shortcuts-card";
            enabled = true;
          }
          {
            id = "audio-card";
            enabled = true;
          }
          {
            id = "brightness-card";
            enabled = true;
          }
          {
            id = "weather-card";
            enabled = true;
          }
          {
            id = "media-sysmon-card";
            enabled = true;
          }
        ];
        shortcuts = {
          left = [
            { id = "WiFi"; }
            { id = "Bluetooth"; }
            { id = "plugin:screen_recorder"; }
            {
              id = "CustomButton";
              icon = "rocket";
              leftClickExec = "noctalia-shell ipc call launcher toggle";
            }
          ];
        };
      };
      dock = {
        floatingRatio = 0;
        size = 2;
        animationSpeed = 2;
      };
      sessionMenu.largeButtonsStyle = true;
      osd.location = "bottom_center";
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
      colorSchemes.useWallpaperColors = true;
      desktopWidgets = {
        enabled = true;
        gridSnap = true;
      };
    };
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
