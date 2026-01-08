{
  inputs,
  host,
  config,
  ...
}:
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia-shell = {
    enable = true;
    colors = with config.lib.stylix.colors.withHashtag; {
      mError = base08;
      mOnError = base01;
      mOnPrimary = base04;
      mOnSecondary = base03;
      mOnTertiary = base02;
      mOnSurface = base03;
      mOnSurfaceVariant = base02;
      mOnHover = base07;
      mOutline = base02;
      mPrimary = base04;
      mSecondary = base03;
      mTertiary = base05;
      mShadow = base00;
      mSurface = base01;
      mSurfaceVariant = base02;
      mHover = base03;
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
            {
              id = "CustomButton";
              icon = "rocket";
              leftClickExec = "noctalia-shell ipc call launcher toggle";
            }
            {
              id = "Clock";
              usePrimaryColor = false;
            }
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
            { id = "ScreenRecorder"; }
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
      location = {
        name = "Hod Hasharon, Israel";
        showWeekNumberInCalendar = true;
      };
      screenRecorder.copyToClipboard = true;
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
  };
}
