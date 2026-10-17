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
        "browser.ctrlTab.sortByRecentlyUsed" = true;
        "browser.tabs.fadeOutUnloadedTabs" = true;
        "browser.tabs.hoverPreview.enabled" = true;
        "security.enterprise_roots.enabled" = true;
        "sidebar.position_start" = false;
        "zen.theme.content-element-separation" = 0;
        "zen.theme.hide-tab-throbber" = false;
        "zen.urlbar.behavior" = "float";
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
    profiles.default = {
      id = 0;
      name = profile_name;
      isDefault = true;
    };
  };
  home.sessionVariables.BROWSER = "zen-twilight";
}
