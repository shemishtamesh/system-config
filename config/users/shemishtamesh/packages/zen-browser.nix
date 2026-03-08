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
      Preferences = {
        browser = {
          ctrlTab.sortByRecentlyUsed = true;
          tabs = {
            fadeOutUnloadedTabs = true;
            hoverPreview.enabled = true;
          };
        };
        sidebar.position_start = false;
        zen = {
          theme = {
            content-element-separation = 0;
            hide-tab-throbber = false;
          };
          urlbar.behavior = "float";
          view = {
            compact = {
              hide-toolbar = true;
              toolbar-flash-popup = true;
            };
            use-single-toolbar = false;
          };
          welcome-screen.seen = true;
          window-sync.sync-only-pinned-tabs = true;
          workspaces = {
            container-specific-essentials-enabled = true;
            scroll-modifier-key = "shift";
          };
        };
      };
    };
    profiles.default = {
      id = 0;
      name = profile_name;
      isDefault = true;
    };
  };
  home.sessionVariables.BROWSER = "zen";
}
