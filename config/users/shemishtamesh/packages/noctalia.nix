{
  inputs,
  host,
  pkgs,
  config,
  ...
}:
{
  imports = [
    inputs.noctalia.homeModules.default
  ];
  programs.noctalia-shell = {
    enable = true;
    package =
      let
        noctalia-package = pkgs.lib.getExe (
          inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
            calendarSupport = true;
          }
        );
      in
      (pkgs.writeShellScriptBin "noctalia-shell" ''
        if [ "$1" = "kill" ]; then
          ${noctalia-package} "$@"
          exit 0
        fi
        ${noctalia-package} "$@" &
        pid="$!"

        sleep 3 # set location doesn't seem to work immediately
        ${noctalia-package} ipc call location set "$(cat ${config.sops.secrets.location.path})"

        wait $pid
      '');
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
        dockType = "static";
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
      colorSchemes.useWallpaperColors = true;
      desktopWidgets = {
        enabled = true;
        gridSnap = true;
      };
    };
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
