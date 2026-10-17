{
  inputs,
  ...
}:
let
  profile_name = "default";
in
{
  imports = [ inputs.zen-browser.homeModules.twilight ];
  stylix.targets.zen-browser.profileNames = [ profile_name ];
  programs.zen-browser = {
    enable = true;
    policies = {
      AutofillAddressEnabled = true;
      AutofillCreditCardEnabled = false;
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
    };
    profiles.default = {
      id = 0;
      name = profile_name;
      isDefault = true;
      # Close Zen before activating changes to containers, spaces, or pins.
      containers = {
        Personal = {
          id = 1;
          color = "purple";
          icon = "fingerprint";
        };
        Work = {
          id = 2;
          color = "blue";
          icon = "briefcase";
        };
      };
      spaces = {
        Personal = {
          id = "c6de089c-410d-4206-961d-ab11f988d40a";
          position = 1000;
          icon = "🏠";
          container = 1;
          pins.YouTube = {
            id = "12ab54cf-ec28-43ea-9b61-a734e3b981de";
            url = "https://www.youtube.com/";
            container = 1;
            position = 100;
          };
        };
        Work = {
          id = "cdd10fab-4fc5-494b-9041-325e5759195b";
          position = 2000;
          icon = "💼";
          container = 2;
          pins = {
            "Google Calendar" = {
              id = "9a2b3e4f-1567-48d9-a012-45ba67cd89ef";
              url = "https://calendar.google.com/";
              container = 2;
              position = 100;
              isEssential = true;
            };
            Gmail = {
              id = "c87d63e1-490f-4a52-bca7-981b302de654";
              url = "https://mail.google.com/";
              container = 2;
              position = 200;
              isEssential = true;
            };
            Jira = {
              id = "a470fee1-7c21-4bd0-9126-2ee9e9c8c86f";
              url = "https://agamanalytics.atlassian.net/";
              container = 2;
              position = 300;
              isEssential = true;
            };
          };
        };
      };
      settings = {
        "browser.toolbars.bookmarks.visibility" = "always";
        "browser.ctrlTab.sortByRecentlyUsed" = true;
        "browser.tabs.fadeOutUnloadedTabs" = true;
        "browser.tabs.hoverPreview.enabled" = true;
        "security.enterprise_roots.enabled" = true;
        "sidebar.position_start" = false;
        "zen.theme.content-element-separation" = 0;
        "zen.theme.hide-tab-throbber" = false;
        "zen.urlbar.behavior" = "float";
        "zen.view.compact.enable-at-startup" = true;
        "zen.view.compact.hide-toolbar" = true;
        "zen.view.compact.toolbar-flash-popup" = true;
        "zen.view.compact.toolbar-hide-after-hover.duration" = 250;
        "zen.view.use-single-toolbar" = false;
        "zen.welcome-screen.seen" = true;
        "zen.window-sync.sync-only-pinned-tabs" = true;
        "zen.workspaces.container-specific-essentials-enabled" = true;
        "zen.workspaces.scroll-modifier-key" = "shift";
      };
    };
  };
  home.sessionVariables.BROWSER = "zen-twilight";
}
