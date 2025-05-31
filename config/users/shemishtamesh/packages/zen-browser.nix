{
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.zen-browser.homeModules.twilight ];
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
      };
    };
    nativeMessagingHosts = [ pkgs.firefoxpwa ];
    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;
      userChrome = # css
        ''
          #tabbrowser-tabpanels > hbox {
            margin: 0px!important;
          }
        '';
    };
  };
}
