{
  pkgs,
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
        "zen.theme.content-element-separation" = 0;
        "zen.view.use-single-toolbar" = false;
        "zen.view.compact.hide-toolbar" = true;
        "zen.view.compact.toolbar-flash-popup" = true;
        "zen.urlbar.behavior" = "float";
        "zen.welcome-screen.seen" = true;
        "zen.workspaces.container-specific-essentials-enabled" = true;
        "sidebar.position_start" = false;
      };
    };
    nativeMessagingHosts = [ pkgs.firefoxpwa ];
    profiles.default = {
      id = 0;
      name = profile_name;
      isDefault = true;
    };
  };
  sessionVariables.BROWSER = "zen";
}
