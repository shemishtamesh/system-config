{ inputs, ... }:
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia-shell = {
    enable = true;
    settings = {
      settingsVersion = 0;
      general = {
        showHibernateOnLockScreen = true;
        enableShadows = false;
      };
      bar = {
        marginVertical = 0;
        marginHorizontal = 0;
        outerCorners = false;
        widgets = {
          left = [
            {
              id = "Clock";
              usePrimaryColor = false;
            }
            {
              id = "SystemMonitor";
            }
            {
              id = "ActiveWindow";
            }
            {
              id = "MediaMini";
            }
          ];
          center = [
            {
              id = "Workspace";
              showApplications = true;
            }
          ];
        };
      };
      osd.location = "bottom_center";
      notifications.location = "top_center";
      location.name = "Hod Hasharon, Israel";
      screenRecorder.copyToClipboard = true;
      wallpaper.enabled = false;
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
